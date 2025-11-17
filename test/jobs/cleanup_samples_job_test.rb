require "test_helper"

class CleanupSamplesJobTest < ActiveJob::TestCase
  test "cleans up samples older than 25 hours" do
    travel_to Time.current do
      measurement = measurements(:puma_backlog)

      measurement.samples.create!(timestamp: (25.hours + 1.minute).ago)
      measurement.samples.create!(timestamp: 25.hours.ago)
      measurement.samples.create!(timestamp: (25.hours - 1.minute).ago)

      perform_enqueued_jobs do
        assert_difference("Sample.count", -1) do
          CleanupSamplesJob.perform_later
        end
      end
    end
  end
end
