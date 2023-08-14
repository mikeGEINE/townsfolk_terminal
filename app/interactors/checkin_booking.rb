# frozen_string_literal: true

require 'dry/monads'

class CheckinBooking < BasicInteractor
  param :booking_params

  def call
    find_booking(booking_params[:booking_id])
      .bind { |booking| check_status booking }
      .bind { |booking| get_room_for booking }
  end

  private

  def find_booking(id)
    Try[ActiveRecord::RecordNotFound] { Booking.find(id) }
      .to_result
      .or Failure(:booking_not_found)
  end

  def check_status(booking)
    return Failure(:out_of_date) unless booking.time_valid?

    if booking.paid?
      Success(booking)
    elsif booking.created?
      Failure(:booking_not_paid)
    else
      Failure(:booking_already_complete)
    end
  end

  def get_room_for(booking)
    rooms = booking.rooms.filter(&:ready?)
    if rooms.empty?
      Failure(:no_rooms_available)
    else
      rooms.first.occupied!
      booking.complete!
      Success(rooms.first)
    end
  end
end
