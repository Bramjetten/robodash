module API
  class APIController < ActionController::Base
    before_action :set_current_dashboard

    private

      def set_current_dashboard
        Current.dashboard = Dashboard.first
      end

  end
end

