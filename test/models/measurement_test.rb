require "test_helper"

class MeasurementTest < ActiveSupport::TestCase
  test "#value returns the latest value" do
    measurement = measurements(:puma_backlog)
    measurement.samples.create(value: 1, timestamp: 1.minute.ago)
    measurement.samples.create(value: 2, timestamp: 2.minutes.ago)

    assert_equal 1, measurement.value
  end

  test "#graph_samples aggregates every bucket, including the open one, and ends on the latest sample" do
    bucket = AggregateSamplesJob::BUCKET
    travel_to Time.current.beginning_of_hour + bucket / 2

    measurement = measurements(:puma_backlog)
    # Already aggregated by the job
    measurement.samples.create!(timestamp: (bucket + 10.minutes).ago, value: 5, min: 2, max: 9)
    # Raw samples in the open bucket
    measurement.samples.create!(timestamp: 8.minutes.ago, value: 7)
    measurement.samples.create!(timestamp: 6.minutes.ago, value: 1)
    measurement.samples.create!(timestamp: 1.minute.ago, value: 4)

    points = measurement.graph_samples

    assert_equal [ [ 30.minutes.ago, 2, 5, 9 ], [ 10.minutes.ago, 1, 4, 7 ], [ 1.minute.ago, nil, 4, nil ] ],
      points.map { [ it.timestamp, it.min, it.value, it.max ] }
  end
end
