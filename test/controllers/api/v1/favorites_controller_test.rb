require "test_helper"

class API::V1::FavoritesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @widget = widgets(:puma_backlog)
  end

  def headers(user = users(:nick))
    { "Authorization": "Bearer #{user.sessions.create!.signed_id(purpose: :api)}" }
  end

  test "should favorite a widget" do
    assert_difference("users(:nick).favorites.count") do
      post api_v1_widget_favorite_url(@widget), headers:, as: :json
    end
    assert_response :no_content

    # Favoriting twice is fine
    assert_no_difference("Favorite.count") do
      post api_v1_widget_favorite_url(@widget), headers:, as: :json
    end
  end

  test "should unfavorite a widget" do
    users(:nick).favorites.create!(widget: @widget)

    assert_difference("Favorite.count", -1) do
      delete api_v1_widget_favorite_url(@widget), headers:, as: :json
    end
    assert_response :no_content
  end

  test "should show favorites of the current user only" do
    users(:nick).favorites.create!(widget: @widget)
    other = User.create!(email_address: "other@plango.nl", password: "password")
    accounts(:plango).users << other

    get api_v1_dashboard_url(dashboards(:plango)), headers:, as: :json
    assert response.parsed_body["widgets"].sole["favorite"]

    get api_v1_dashboard_url(dashboards(:plango)), headers: headers(other), as: :json
    assert_not response.parsed_body["widgets"].sole["favorite"]
  end

  test "should not favorite widgets of other accounts" do
    other = User.create!(email_address: "other@example.com", password: "password")

    post api_v1_widget_favorite_url(@widget), headers: headers(other), as: :json
    assert_response :not_found
  end
end
