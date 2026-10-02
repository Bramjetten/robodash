# GET api/v1/widgets/:id -> a widget with its history (readings and status changes)
module API
  module V1
    class WidgetsController < BaseController

      def show
        @widget = Widget.where(dashboard: Current.user.dashboards).includes(:widgetable).find(params[:id])
        @favorite_widget_ids = Current.user.favorites.where(widget: @widget).pluck(:widget_id).to_set
      end

    end
  end
end
