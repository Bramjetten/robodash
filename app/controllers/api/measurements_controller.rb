# POST api/measurements#create
# Body:
# - name (required)
# - value (required)
# - unit
module API
  class MeasurementsController < APIController
    before_action :find_measurement

    def create
      if @measurement.update(measurement_params) && @measurement.samples.create(sample_params)
        render json: @measurement.widget.to_json(only: [:name], methods: [:status])
      else
        render json: { errors: @measurement.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

      def sample_params
        params.permit(:value, :timestamp)
      end

      def measurement_params
        params.permit(:unit)
      end

      def find_measurement
        @measurement = Measurement.find_or_create_by_name!(params[:name])
      end

  end
end
