module API
  class APIController < ActionController::Base
    before_action :set_current_dashboard

    private

      def set_current_dashboard
        Current.dashboard = Dashboard.find_by!(dashboard_token: dashboard_token)
      rescue ActiveRecord::RecordNotFound
        render json: {error: "Dashboard not found"}, status: :unauthorized
      end
      
      def dashboard_token
        request.headers["Authorization"]&.split(" ")&.last
      end

  end
end

