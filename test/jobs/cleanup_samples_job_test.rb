require "test_helper"

class CleanupSamplesJobTest < ActiveJob::TestCase
  test "cleans up samples older than the window" do
    travel_to Time.current do
      measurements(:puma_backlog).samples.create!(timestamp: (Measurement::SAMPLE_WINDOW + 1.minute).ago)
      measurements(:puma_backlog).samples.create!(timestamp: Measurement::SAMPLE_WINDOW.ago)
      measurements(:puma_backlog).samples.create!(timestamp: (Measurement::SAMPLE_WINDOW - 1.minute).ago)

      perform_enqueued_jobs do
        assert_difference("Sample.count", -1) do
          CleanupSamplesJob.perform_later
        end
      end
    end
  end
end
