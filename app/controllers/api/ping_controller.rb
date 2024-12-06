module API
  class PingController < APIController
    before_action :find_widget

    def create
      @heartbeat = @widget.widgetable
      @heartbeat.ping!
    end

    private

      def find_widget
        @widget = Current.dashboard.widgets.heartbeats.find_by!(name: params[:name])
      rescue ActiveRecord::RecordNotFound
        render json: {error: "Widget not found"}, status: :not_found
      end

  end
end

