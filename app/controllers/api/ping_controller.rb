# PingController is only meant for Heartbeats right now
module API
  class PingController < APIController
    before_action :find_heartbeat

    def create
      @heartbeat.ping! # Pinging a heartbeat sets its pinged_at to the current time
      render json: @heartbeat.widget.to_json
    end

    private

      def find_heartbeat
        @heartbeat = Heartbeat.find_by_name!(params[:name])
      rescue ActiveRecord::RecordNotFound
        render json: {error: "Widget not found"}, status: :not_found
      end

  end
end

