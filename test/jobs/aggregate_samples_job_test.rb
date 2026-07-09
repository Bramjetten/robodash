require "test_helper"

class AggregateSamplesJobTest < ActiveJob::TestCase
  setup do
    @bucket = AggregateSamplesJob::BUCKET
    travel_to Time.current.beginning_of_hour + @bucket / 2
  end

  test "aggregates completed buckets only" do
    measurement = measurements(:puma_backlog)

    # To be aggregated
    measurement.samples.create!(timestamp: (@bucket + 5.minutes).ago)
    measurement.samples.create!(timestamp: (@bucket + 4.minutes).ago, value: 1)

    # Within the latest window
    measurement.samples.create!(timestamp: 5.minutes.ago)
    measurement.samples.create!(timestamp: 4.minutes.ago)

    perform_enqueued_jobs do
      assert_difference("Sample.count", -1) do
        AggregateSamplesJob.perform_later
      end
    end

    aggregated = measurement.samples.first
    assert_equal 30.minutes.ago, aggregated.timestamp
    assert_equal 1, aggregated.max

    # The open bucket keeps its raw samples.
    assert_equal 2, measurement.samples.where(min: nil).count
  end

  test "correctly aggregates the min, median, and max values" do
    measurement = measurements(:puma_backlog)

    measurement.samples.create!(timestamp: (@bucket + 5.minutes).ago, value: 4)
    measurement.samples.create!(timestamp: (@bucket + 4.minutes).ago, value: 3)
    measurement.samples.create!(timestamp: (@bucket + 3.minutes).ago, value: 1)

    perform_enqueued_jobs do
      assert_difference("Sample.count", -2) do
        AggregateSamplesJob.perform_later
      end
    end

    aggregated = measurement.samples.first
    assert_equal 30.minutes.ago, aggregated.timestamp
    assert_equal 1, aggregated.min
    assert_equal 3, aggregated.value
    assert_equal 4, aggregated.max
  end

  test "does not aggregate buckets with a single sample" do
    measurement = measurements(:puma_backlog)

    measurement.samples.create!(timestamp: (@bucket + 5.minutes).ago, value: 4)

    perform_enqueued_jobs do
      assert_no_difference("Sample.count") do
        AggregateSamplesJob.perform_later
      end
    end

    assert_nil measurement.samples.first.min
  end
end
