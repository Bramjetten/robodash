# PingController is only meant for Heartbeats right now
# Works like this: POST api/ping#create
# Body:
# - name (required)
# - schedule_number
# - schedule_period
# - grace_period
module API
  class PingController < APIController
    before_action :find_heartbeat

    def create
      if @heartbeat.update(heartbeat_params) # This updates pinged_at *and* any heartbeat settings
        render json: @heartbeat.widget.to_json(only: [:name], methods: [:status])
      else
        render json: {errors: @heartbeat.errors.full_messages}, status: :unprocessable_entity
      end
    end

    private

      # These attributes can be set using the API
      # That way it's possible to setup a new heartbeat without using the UI
      # (or update its schedule)
      def heartbeat_params
        params.permit(:schedule_number, :schedule_period, :grace_period).merge(pinged_at: Time.current)
      end

      def find_heartbeat
        @heartbeat = Heartbeat.find_or_create_by_name!(params[:name])
      end

  end
end

