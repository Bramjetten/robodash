# Base controller for the Robodash companion apps (iOS, watchOS)
#
# Unlike API::APIController (which authenticates a single dashboard by its token),
# these endpoints authenticate a user with a bearer token that points to a Session.
# Destroying the session revokes the token.
module API
  module V1
    class BaseController < ActionController::API
      before_action :authenticate

      private

        def authenticate
          Current.session = Session.find_signed(bearer_token, purpose: :api) if bearer_token.present?
          render json: { error: "Unauthorized" }, status: :unauthorized unless Current.session
        end

        def bearer_token
          request.headers["Authorization"]&.split(" ")&.last
        end

    end
  end
end
