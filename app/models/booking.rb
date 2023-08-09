# frozen_string_literal: true

class Booking < ApplicationRecord
  belongs_to :category
  has_many :rooms, through: :category

  enum :status, %i[created paid complete]

  def time_valid?
    # Check if the booking is still within its start and end dates.
    if Time.zone.today.between? start_date, end_date
      # If the booking's end date is today, check if it's before 12:00.
      return false if end_date == Time.zone.today && Time.zone.now.hour >= 12

      return true
    end
    false
  end
end
