# POST api/v1/session
# Body:
# - email_address (required)
# - password (required)
#
# Returns a token to use as "Authorization: Bearer <token>"
module API
  module V1
    class SessionsController < BaseController
      skip_before_action :authenticate, only: :create
      rate_limit to: 10, within: 3.minutes, only: :create, with: -> { render json: { error: "Try again later." }, status: :too_many_requests }

      def create
        if user = User.authenticate_by(params.permit(:email_address, :password))
          session = user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip)
          render json: { token: session.signed_id(purpose: :api), email_address: user.email_address }, status: :created
        else
          render json: { error: "Try another email address or password." }, status: :unauthorized
        end
      end

      def destroy
        Current.session.destroy
        head :no_content
      end

    end
  end
end
