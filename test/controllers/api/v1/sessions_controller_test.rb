require "test_helper"

class API::V1::SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should return a token for valid credentials" do
    assert_difference("Session.count") do
      post api_v1_session_url, params: { email_address: "nick@plango.nl", password: "password" }, as: :json
    end

    assert_response :created
    assert_equal Session.last, Session.find_signed(response.parsed_body["token"], purpose: :api)
  end

  test "should not return a token for invalid credentials" do
    assert_no_difference("Session.count") do
      post api_v1_session_url, params: { email_address: "nick@plango.nl", password: "wrong" }, as: :json
    end

    assert_response :unauthorized
  end

  test "should revoke the token on destroy" do
    session = users(:nick).sessions.create!
    token = session.signed_id(purpose: :api)

    delete api_v1_session_url, headers: { "Authorization": "Bearer #{token}" }, as: :json
    assert_response :no_content

    get api_v1_dashboards_url, headers: { "Authorization": "Bearer #{token}" }, as: :json
    assert_response :unauthorized
  end
end
