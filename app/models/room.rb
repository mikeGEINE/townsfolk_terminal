# frozen_string_literal: true

class Room < ApplicationRecord
  belongs_to :category

  enum :status, %i[ready occupied housekeeping]
end
