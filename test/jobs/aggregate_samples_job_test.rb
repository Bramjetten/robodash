require "test_helper"

class AggregateSamplesJobTest < ActiveJob::TestCase
  test "aggregates older samples only" do
    travel_to Time.current do
      measurement = measurements(:puma_backlog)

      measurement.samples.create!(timestamp: 61.minutes.ago)
      measurement.samples.create!(timestamp: 61.minutes.ago, value: 1)
      measurement.samples.create!(timestamp: 60.minutes.ago)
      measurement.samples.create!(timestamp: 59.minutes.ago)

      perform_enqueued_jobs do
        assert_difference("Sample.count", -1) do
          AggregateSamplesJob.perform_later
        end
      end

      assert_equal 61.minutes.ago.beginning_of_minute, measurement.samples.first.timestamp
      assert_equal 1, measurement.samples.first.max
    end
  end

  test "correctly aggregates the min, median, and max values" do
    travel_to Time.current do
      measurement = measurements(:puma_backlog)

      measurement.samples.create!(timestamp: 61.minutes.ago, value: 4)
      measurement.samples.create!(timestamp: 61.minutes.ago, value: 3)
      measurement.samples.create!(timestamp: 61.minutes.ago, value: 1)

      perform_enqueued_jobs do
        assert_difference("Sample.count", -2) do
          AggregateSamplesJob.perform_later
        end
      end

      assert_equal 61.minutes.ago.beginning_of_minute, measurement.samples.first.timestamp
      assert_equal 1, measurement.samples.first.min
      assert_equal 3, measurement.samples.first.value
      assert_equal 4, measurement.samples.first.max
    end
  end
end
