# POST   api/v1/widgets/:widget_id/favorite
# DELETE api/v1/widgets/:widget_id/favorite
module API
  module V1
    class FavoritesController < BaseController
      before_action :set_widget

      def create
        Current.user.favorites.find_or_create_by!(widget: @widget)
        head :no_content
      end

      def destroy
        Current.user.favorites.where(widget: @widget).destroy_all
        head :no_content
      end

      private

        def set_widget
          @widget = Widget.where(dashboard: Current.user.dashboards).find(params[:widget_id])
        end

    end
  end
end
