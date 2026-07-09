class AggregateSamplesJob < ApplicationJob
  BUCKET = 20.minutes

  def perform
    Measurement.find_each do |measurement|
      measurement.transaction do
        aggregated_samples = measurement
          .samples
          .where(timestamp: aggregation_window)
          .select("group_concat(id) as ids, datetime((strftime('%s', samples.timestamp) / #{BUCKET.to_i}) * #{BUCKET.to_i}, 'unixepoch') AS timestamp, MIN(value) as min, MEDIAN(value) as value, MAX(value) as max")
          .group("strftime('%s', samples.timestamp) / #{BUCKET.to_i}")
          .having("COUNT(id) > 1")

        measurement.samples.where(id: aggregated_samples.flat_map { _1.ids.split(",").map(&:to_i) }).delete_all
        measurement.samples.insert_all(aggregated_samples.as_json(only: [:timestamp, :value, :min, :max]))
      end
    end
  end

  private

    def aggregation_window
      # Window during which we aggregate samples, delayed samples that
      # come in after this window will not be aggregated.
      24.hours.ago...current_bucket_start
    end

    def current_bucket_start
      Time.zone.at(Time.current.to_i / BUCKET.to_i * BUCKET.to_i)
    end
end
