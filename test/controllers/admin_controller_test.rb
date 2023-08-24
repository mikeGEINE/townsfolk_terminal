require "test_helper"

class AdminControllerTest < ActionDispatch::IntegrationTest
  test "should get view_accounts" do
    get admin_view_accounts_url
    assert_response :success
  end

  test "should get view_room" do
    get admin_view_room_url
    assert_response :success
  end

  test "should get update_account" do
    get admin_update_account_url
    assert_response :success
  end

  test "should get update_room" do
    get admin_update_room_url
    assert_response :success
  end
end
