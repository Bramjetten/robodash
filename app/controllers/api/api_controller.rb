module API
  class APIController < ActionController::API
    before_action :set_current_dashboard

    private

      def set_current_dashboard
        Current.dashboard = Dashboard.find_by!(token: dashboard_token)
      rescue ActiveRecord::RecordNotFound
        render json: {error: "Dashboard not found"}, status: :not_found
      end
      
      def dashboard_token
        request.headers["Authorization"]&.split(" ")&.last
      end

  end
end

