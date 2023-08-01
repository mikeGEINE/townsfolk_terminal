require "test_helper"

class BookingControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get booking_create_url
    assert_response :success
  end

  test "should get paid" do
    get booking_paid_url
    assert_response :success
  end

  test "should get input" do
    get booking_input_url
    assert_response :success
  end

  test "should get checkin" do
    get booking_checkin_url
    assert_response :success
  end
end
