require "test_helper"

class API::V1::DashboardsControllerTest < ActionDispatch::IntegrationTest
  def headers
    { "Authorization": "Bearer #{users(:nick).sessions.create!.signed_id(purpose: :api)}" }
  end

  test "should require a token" do
    get api_v1_dashboards_url, as: :json
    assert_response :unauthorized

    get api_v1_dashboards_url, headers: { "Authorization": "Bearer #{dashboards(:plango).token}" }, as: :json
    assert_response :unauthorized
  end

  test "should list dashboards with a status summary" do
    get api_v1_dashboards_url, headers:, as: :json
    assert_response :success

    dashboard = response.parsed_body["dashboards"].sole
    assert_equal "PlanGo", dashboard["name"]
    assert_equal "down", dashboard["status"] # Measurement without samples is down
    assert_equal({ "total" => 1, "up" => 0, "down" => 1, "pending" => 0, "warning" => 0 }, dashboard["counts"])
    assert_equal [ "Puma Backlog" ], dashboard["down_widgets"]
  end

  test "should show a dashboard with its widgets" do
    measurements(:puma_backlog).samples.create!(value: 4)

    get api_v1_dashboard_url(dashboards(:plango)), headers:, as: :json
    assert_response :success

    assert_equal "up", response.parsed_body["status"]
    widget = response.parsed_body["widgets"].sole
    assert_equal "measurement", widget["type"]
    assert_equal "up", widget["status"]
    assert_equal 4, widget["measurement"]["value"]
    assert_equal 1, widget["measurement"]["samples"].size
  end

  test "should not show dashboards of other accounts" do
    other = Account.create!(name: "Other").dashboards.create!(name: "Secret")

    get api_v1_dashboard_url(other), headers:, as: :json
    assert_response :not_found
  end
end
