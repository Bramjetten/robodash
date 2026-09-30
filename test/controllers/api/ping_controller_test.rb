require "test_helper"

class API::PingControllerTest < ActionDispatch::IntegrationTest
  def headers
    { "Authorization": dashboards(:plango).token }
  end

  test "should create a new heartbeat if it does not exist" do
    assert_difference([ "Heartbeat.count", "Widget.count" ]) do
      post api_ping_url, params: { name: "Nightly backup" }, headers:
    end

    assert_response :success
    assert_equal "up", response.parsed_body["status"]
  end

  test "should ping an existing heartbeat" do
    post api_ping_url, params: { name: "Nightly backup" }, headers: headers

    assert_no_difference("Heartbeat.count") do
      post api_ping_url, params: { name: "Nightly backup" }, headers:
    end

    assert_response :success
  end
end
