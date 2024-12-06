# PingController is only meant for Heartbeats right now
module API
  class PingController < APIController
    before_action :find_widget

    def create
      @widget.widgetable.ping! # Pinging a heartbeat sets its pinged_at to the current time
      render json: @widget.to_json
    end

    private

      def find_widget
        @widget = Current.dashboard.widgets.heartbeats.find_by!(name: params[:name])
      rescue ActiveRecord::RecordNotFound
        render json: {error: "Widget not found"}, status: :not_found
      end

  end
end

