# CountController is only meant for Counters right now
# Works like this: POST api/count#create
# Body:
# - name (required)
# - count (required)
# - min
# - max
module API
  class CountController < APIController
    before_action :find_counter

    def create
      if @counter.update(counter_params)
        render json: @counter.widget.to_json(only: [:name], methods: [:status])
      else
        render json: {errors: @counter.errors.full_messages}, status: :unprocessable_entity
      end
    end

    private

      # These attributes can be set using the API
      # That way it's possible to setup a new heartbeat without using the UI
      # (or update its schedule)
      def counter_params
        params.expect(:count, :min, :max)
      end

      def find_counter
        @counter = Counter.find_or_create_by_name!(params[:name])
      end

  end
end

