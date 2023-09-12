# frozen_string_literal: true

require 'json_fix.rb'
require 'dry/monads'

class Bnovo
  include Singleton
  include Dry::Monads[:maybe, :result, :try]

  attr_reader :client
  # attr_reader :booking_status

  def initialize
    @_auth = false
    @client = Faraday.new(ENV['BNOVO_API_URL']) do |conn|
      conn.headers['Content-Type'] = 'application/json'
      conn.headers['Accept'] = 'application/json'

      conn.request :json
      conn.response :json
      conn.response :json_fix
      conn.response :follow_redirects
      conn.use :cookie_jar
      conn.response :raise_error
      conn.adapter Faraday.default_adapter
    end
  end

  class << self
    def booking_status
      @@booking_status ||= {new: "1", canceled: "2", checkin: "3", checkout: "4", confirmed: "5", pending: "6"}
    end
  end

  def rooms
    make_request(:get, 'room')
  end

  def room_types
    make_request(:get, 'roomTypes/get')
  end

  def find_booking(booking_id)
    make_request(:get, 'dashboard', {q: booking_id})
  end

  def find_booking_by_id(id)
    make_request(:get, "booking/general/#{id}")
  end

  def change_booking_status(booking_id,
                            # booking_number,  # Turns out to be optional
                            new_status_id,
                            cancel_reason_id=0,
                            concierge_checkout=0,
                            is_checkin=0)
    make_request(:post, 'booking/change_booking_status',
      { booking_id: booking_id,
        # booking_number: booking_number,     #Turns out to be optional
        new_status_id: new_status_id,
        cancel_reason_id: cancel_reason_id,
        concierge_checkout: concierge_checkout,
        is_checkin: is_checkin},
        {'X-Requested-With': 'XMLHttpRequest'})
  end

  private

  def make_request(method, path, body = nil, headers = nil)
    if authenticated?
      try_request(method, path, body, headers)
    else
      auth.bind { try_request(method, path, body, headers) }
    end
  end

  def authenticated?
    cookie = client.app.app.app.app.app.as_json["jar"][0]
    @_auth && cookie ? (Time.now - Time.parse(cookie["created_at"])) < 1.hour : false
  end

  def auth
    try_request(:post, '', {username: ENV['BNOVO_API_USERNAME'], password: ENV['BNOVO_API_PASSWORD']}).bind do |body|
      if body.exclude?("is_mobile")
        @_auth = true
        Success(body)
      else
        @_auth = false
        Failure(:bnovo_authentication_failed)
      end
    end
  end

  def try_request(method, path, body = nil, headers = nil)
    Try[Faraday::Error] {client.send method, path, body, headers}.fmap { |resp| resp.body }
      .to_result
      .or { |e| Failure(e.class.name.underscore.to_sym) }
  end
end
