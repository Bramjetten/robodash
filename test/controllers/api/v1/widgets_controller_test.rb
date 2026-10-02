require "test_helper"

class API::V1::WidgetsControllerTest < ActionDispatch::IntegrationTest
  def headers(user = users(:nick))
    { "Authorization": "Bearer #{user.sessions.create!.signed_id(purpose: :api)}" }
  end

  test "shows a widget with its history" do
    Current.dashboard = dashboards(:plango)
    counter = Counter.find_or_create_by_name!("Failed jobs")
    counter.update!(count: 3)
    counter.update!(count: 30, max: 10)

    get api_v1_widget_url(counter.widget), headers:, as: :json
    assert_response :success

    body = response.parsed_body
    assert_equal "Failed jobs", body["name"]
    assert_equal [ 3, 30 ], body["readings"].map { it["value"] }
    assert_equal [ "down" ], body["status_changes"].map { it["status"] }
  end

  test "only widgets on the user's own dashboards" do
    other = User.create!(email_address: "other@example.com", password: "password")

    get api_v1_widget_url(widgets(:puma_backlog)), headers: headers(other), as: :json
    assert_response :not_found
  end
end
