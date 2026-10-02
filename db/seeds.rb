# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Demo data for local development (and testing the iOS app against bin/dev)
# Sign in with demo@robodash.app / password
if Rails.env.development?
  user = User.find_or_create_by!(email_address: "demo@robodash.app") { it.password = "password" }
  account = Account.find_or_create_by!(name: "Demo")
  account.users << user unless account.users.include?(user)

  # UptimeMonitors need a URL, so they can't be created by name alone
  def uptime_monitor(name, url)
    Current.dashboard.widgets.find_by(name:, widgetable_type: "UptimeMonitor")&.widgetable ||
      Current.dashboard.widgets.create!(name:, widgetable: UptimeMonitor.new(url:)).widgetable
  end

  # History for the widget details in the iOS app (only when there's none from the last day yet)
  def seed_history(widgetable)
    widget = widgetable.widget
    return if widget.readings.where(created_at: 25.hours.ago..).exists?

    yield widget
  end

  # Production: everything up, one warning
  Current.dashboard = account.dashboards.find_or_create_by!(name: "Production")

  nightly_backup = Heartbeat.find_or_create_by_name!("Nightly backup")
  seed_history(nightly_backup) do |widget|
    # Every night around 03:00 for the last month
    30.downto(1) { |day| widget.readings.create!(created_at: day.days.ago.change(hour: 3, min: rand(10))) }
  end
  nightly_backup.update!(pinged_at: 2.hours.ago)

  sync_invoices = Heartbeat.find_or_create_by_name!("Sync invoices")
  sync_invoices.update!(schedule_period: "hour")
  seed_history(sync_invoices) do |widget|
    24.downto(1) { |hour| widget.readings.create!(created_at: hour.hours.ago - rand(5).minutes) }
  end
  sync_invoices.update!(pinged_at: 20.minutes.ago)

  failed_jobs = Counter.find_or_create_by_name!("Failed jobs")
  failed_jobs.update!(max: 10)
  seed_history(failed_jobs) do |widget|
    # Every 15 minutes, with a spike above the maximum 6 hours ago
    96.downto(1) do |i|
      count = i.between?(22, 26) ? 12 + rand(4) : rand(6)
      widget.readings.create!(value: count, created_at: (i * 15).minutes.ago)
    end
    widget.status_changes.create!(status: "down", created_at: (26 * 15).minutes.ago)
    widget.status_changes.create!(status: "up", created_at: (21 * 15).minutes.ago)
  end
  failed_jobs.update!(count: 2)

  { "robodash.app" => [ "https://robodash.app/up", 120 ], "API" => [ "https://robodash.app/api", 740 ] }.each do |name, (url, response_time)|
    monitor = uptime_monitor(name, url)
    seed_history(monitor) do |widget|
      # A check every 5 minutes, with a short outage 9 hours ago on robodash.app
      288.downto(1) do |i|
        outage = name == "robodash.app" && i.between?(105, 108)
        widget.readings.create!(
          value: outage ? nil : (response_time * (0.7 + rand * 0.6)).round,
          code: outage ? 503 : 200,
          created_at: (i * 5).minutes.ago
        )
      end
      if name == "robodash.app"
        widget.status_changes.create!(status: "down", created_at: (108 * 5).minutes.ago)
        widget.status_changes.create!(status: "up", created_at: (104 * 5).minutes.ago)
      end
    end
    monitor.update!(response_code: 200, response_time:)
  end

  puma_backlog = Measurement.find_or_create_by_name!("Puma backlog")
  puma_backlog.update!(unit: "req")
  if puma_backlog.samples.where(timestamp: 25.hours.ago..).none?
    # One sample every 20 minutes for the last 24 hours (like AggregateSamplesJob)
    72.downto(0) do |i|
      value = (4 + 3 * Math.sin(i / 6.0) + rand(3)).round
      puma_backlog.samples.create!(timestamp: (i * 20).minutes.ago, value:, min: [ value - rand(3), 0 ].max, max: value + rand(4))
    end
  end

  # Staging: a couple of things down
  Current.dashboard = account.dashboards.find_or_create_by!(name: "Staging")
  Heartbeat.find_or_create_by_name!("Deploy check").update!(pinged_at: 3.days.ago)
  Counter.find_or_create_by_name!("Queue size").update!(count: 42, max: 25)
  uptime_monitor("staging.robodash.app", "https://staging.robodash.app/up").update!(response_code: 200, response_time: 90)

  # Empty dashboard
  account.dashboards.find_or_create_by!(name: "Side projects")

  Current.reset
end
