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
    Bnovo.instance.find_booking(id).bind do |json|
      Maybe(json["bookings"]).maybe do |arr|
        arr.length == 1 ? arr[0] : nil
      end.to_result.or Failure(:booking_not_found)
    end
  end

  def check_status(booking)
    return Failure(:out_of_date) unless time_valid?(booking)

    if Bnovo.booking_status.values_at(:checkin, :confirmed).include? booking["status_id"]
      total = (booking["prices_rooms_total"].to_f + booking["prices_services_total"].to_f)
      debt = (booking["payments_total"].to_f - total).abs
      if debt < 0.01
        Success(booking)
      else
        Failure(:booking_not_paid)
      end
    elsif booking["status_id"] == Bnovo.booking_status[:checkout]
      Failure(:booking_already_complete)
    else
      Failure(:booking_not_found)
    end
  end

  def get_room_for(booking)
    if booking['status_id'] == Bnovo.booking_status[:checkin]
      Success(Room.find_by door: booking["current_room"])
    else
    (Try[ActiveRecord::ActiveRecordError] { Room.find_by(door: booking["current_room"]) }
      .to_maybe.filter(&:ready?).to_result
      .or Failure(:no_rooms_available))
      .bind do |room|
        Bnovo.instance.change_booking_status(booking["id"], Bnovo.booking_status[:checkin])
          .bind do
            room.occupied!
            Success(room)
          end
          .or Failure(:booking_status_update_error)
      end
    end
  end

  def time_valid?(booking)
    # Check if the booking is still within its start and end dates.
    if Time.zone.today.between? Time.zone.parse(booking['arrival']).to_date, Time.zone.parse(booking['departure']).to_date
      # If the booking's end date is today, check if it's before 12:00.
      return false if Time.zone.now.after? Time.zone.parse(booking['departure'])

      return true
    end
    false
  end
end
