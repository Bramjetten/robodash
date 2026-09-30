require "test_helper"

class API::CountControllerTest < ActionDispatch::IntegrationTest
  def headers
    { "Authorization": dashboards(:plango).token }
  end

  test "should create a new counter if it does not exist" do
    assert_difference([ "Counter.count", "Widget.count" ]) do
      post api_count_url, params: { name: "Failed jobs", count: 3, max: 10 }, headers:
    end

    assert_response :success
    assert_equal "up", response.parsed_body["status"]
  end

  test "should alert when a new counter is down right away" do
    assert_difference("Widget.alerted.count") do
      post api_count_url, params: { name: "Failed jobs", count: 30, max: 10 }, headers:
    end

    assert_response :success
    assert_equal "down", response.parsed_body["status"]
  end
end
