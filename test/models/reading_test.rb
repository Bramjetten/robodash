require "test_helper"

class ReadingTest < ActiveSupport::TestCase
  setup do
    Current.dashboard = dashboards(:plango)
  end

  test "heartbeats record their pings" do
    heartbeat = Heartbeat.find_or_create_by_name!("Nightly backup")

    assert_difference("heartbeat.widget.readings.count", 2) do
      heartbeat.update!(pinged_at: 1.hour.ago)
      heartbeat.update!(pinged_at: Time.current)
    end
    assert_no_difference("Reading.count") { heartbeat.update!(grace_period: 120) }
  end

  test "counters record their counts" do
    counter = Counter.find_or_create_by_name!("Failed jobs")

    counter.update!(count: 3)
    counter.update!(count: 5)
    assert_equal [ 3, 5 ], counter.widget.readings.order(:id).pluck(:value)
  end

  test "uptime monitors record their checks, also when the site can't be reached" do
    monitor = dashboards(:plango).widgets.create!(name: "Site", widgetable: UptimeMonitor.new(url: "http://localhost:1/nothing-here")).widgetable

    monitor.ping_for_uptime!
    reading = monitor.widget.readings.sole
    assert_nil reading.code
  end

  test "alerts record status changes" do
    counter = Counter.find_or_create_by_name!("Failed jobs")

    counter.update!(count: 30, max: 10)
    counter.update!(count: 1)
    assert_equal %w[ down up ], counter.widget.status_changes.order(:id).pluck(:status)
  end

  test "old history is cleaned up" do
    widget = Counter.find_or_create_by_name!("Failed jobs").widget
    heartbeat = Heartbeat.find_or_create_by_name!("Nightly backup").widget
    widget.readings.create!(value: 1, created_at: 2.days.ago)
    widget.readings.create!(value: 2, created_at: 1.hour.ago)
    heartbeat.readings.create!(created_at: 2.days.ago) # Pings are kept longer
    widget.status_changes.create!(status: "down", created_at: 40.days.ago)

    CleanupSamplesJob.perform_now

    assert_equal [ 2 ], widget.readings.pluck(:value)
    assert_equal 1, heartbeat.readings.count
    assert_empty widget.reload.status_changes
  end
end
