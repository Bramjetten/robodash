require "test_helper"

class API::V1::PushDevicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @session = users(:nick).sessions.create!
  end

  def headers(session = @session)
    { "Authorization": "Bearer #{session.signed_id(purpose: :api)}" }
  end

  test "should register a device for the current session" do
    post api_v1_push_device_url, params: { token: "abc123", name: "iPhone18,4" }, headers:, as: :json

    assert_response :no_content
    device = @session.push_devices.sole
    assert_equal [ "abc123", "apple", "iPhone18,4" ], [ device.token, device.platform, device.name ]
  end

  test "should move a known device to the new session" do
    post api_v1_push_device_url, params: { token: "abc123" }, headers:, as: :json
    new_session = users(:nick).sessions.create!

    assert_no_difference("ApplicationPushDevice.count") do
      post api_v1_push_device_url, params: { token: "abc123" }, headers: headers(new_session), as: :json
    end

    assert_equal new_session, ApplicationPushDevice.find_by!(token: "abc123").owner
  end

  test "should remove devices when signing out" do
    post api_v1_push_device_url, params: { token: "abc123" }, headers:, as: :json

    assert_difference("ApplicationPushDevice.count", -1) do
      delete api_v1_session_url, headers:, as: :json
    end
  end

  test "should require a token" do
    post api_v1_push_device_url, params: { token: "abc123" }, as: :json
    assert_response :unauthorized
  end
end
