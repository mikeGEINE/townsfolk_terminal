# frozen_string_literal: true

require 'dry/monads'

class UpdateRooms < BasicInteractor
  def call
    get_room_types
      .bind { |types_arr| update_room_types(types_arr) }
      .bind { get_rooms }
      .bind { |rooms_arr| update_rooms(rooms_arr) }
  end

  private

  def get_room_types
    Bnovo.instance.room_types.bind { |json| Maybe(json['roomtypes']).to_result.or Failure(:no_roomtypes_in_response) }
  end

  def update_room_types(types_arr)
    trimmed = types_arr.map { |hash| hash.slice(*Category.attribute_names[0...-2]) }  # Try to extract all attr supported by Category model except timestamps
    return Failure(:not_enough_values) if trimmed.any? { |hash| hash.has_value? nil }
    Try[ActiveRecord::ActiveRecordError] { Category.upsert_all trimmed }
      .to_result
      .or Failure(:database_falure)
  end

  def get_rooms
    Bnovo.instance.rooms.bind { |json| Maybe(json['rooms']).to_result.or Failure(:no_rooms_in_response) }
  end

  def update_rooms(rooms_arr)
    trimmed = rooms_arr.map { |hash| {id: hash['id'], door: hash['name'], category_id: hash['room_type_id'] } }
    return Failure(:not_enough_values) if trimmed.any? { |hash| hash.has_value? nil }
    Try[ActiveRecord::ActiveRecordError] { Room.upsert_all trimmed }
      .to_result
      .or Failure(:database_falure)
  end

end
