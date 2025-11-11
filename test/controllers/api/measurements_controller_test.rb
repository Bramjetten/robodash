require "test_helper"

class API::MeasurementsControllerTest < ActionDispatch::IntegrationTest
  def headers
    { "Authorization": dashboards(:plango).token }
  end

  test "should create a new measurement if it does not exist" do
    assert_difference("Measurement.count") do
      post api_measurements_url, params: { name: "Puma Capacity", value: 5, timestamp: Time.current }, headers:
    end
  end

  test "should create a new sample for an existing measurement" do
    assert_no_difference("Measurement.count") do
      assert_difference("Sample.count") do
        post api_measurements_url, params: { name: "Puma Backlog", value: 4, timestamp: Time.current }, headers:
      end
    end
  end
end
