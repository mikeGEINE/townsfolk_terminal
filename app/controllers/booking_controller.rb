# frozen_string_literal: true

class BookingController < ApplicationController
  def create; end

  def paid; end

  def input; end

  def checkin
    CheckinBooking.call(booking_params).either(
      ->(room) { @room = room },
      ->(failure_msg_key) { @fail = failure_msg_key }
    )
  end

  private

  def booking_params
    params.permit(:booking_id)
  end
end
