class AggregateSamplesJob < ApplicationJob

  def perform
    Measurement.find_each do |measurement|
      measurement.transaction do
        aggregated_samples = measurement
          .samples
          .where(timestamp: aggregation_window)
          .select("group_concat(id) as ids, strftime('%Y-%m-%d %H:%M', samples.timestamp) AS timestamp, MAX(value) as value")
          .group("strftime('%Y-%m-%d %H:%M', samples.timestamp)")
          .having("COUNT(id) > 1")

        measurement.samples.where(id: aggregated_samples.flat_map { _1.ids.split(",").map(&:to_i) }).delete_all
        measurement.samples.insert_all(aggregated_samples.as_json(only: [:timestamp, :value]))
      end
    end
  end

  private

    def aggregation_window
      # Window during which we aggregate samples, delayed samples that
      # come in after this window will not be aggregated.
      24.hours.ago...1.hour.ago
    end
end
