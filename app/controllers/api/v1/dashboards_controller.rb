# GET api/v1/dashboards      -> all dashboards of the current user with a status summary
# GET api/v1/dashboards/:id  -> a single dashboard including its widgets
module API
  module V1
    class DashboardsController < BaseController

      def index
        @dashboards = dashboards.order(:name)
      end

      def show
        @dashboard = dashboards.find(params[:id])
      end

      private

        def dashboards
          Current.user.dashboards.includes(widgets: :widgetable)
        end

    end
  end
end
