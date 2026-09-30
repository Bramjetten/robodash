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

  # Production: everything up, one warning
  Current.dashboard = account.dashboards.find_or_create_by!(name: "Production")
  Heartbeat.find_or_create_by_name!("Nightly backup").update!(pinged_at: 2.hours.ago)
  Heartbeat.find_or_create_by_name!("Sync invoices").update!(schedule_period: "hour", pinged_at: 20.minutes.ago)
  Counter.find_or_create_by_name!("Failed jobs").update!(count: 2, max: 10)
  uptime_monitor("robodash.app", "https://robodash.app/up").update!(response_code: 200, response_time: 120)
  uptime_monitor("API", "https://robodash.app/api").update!(response_code: 200, response_time: 740)

  puma_backlog = Measurement.find_or_create_by_name!("Puma backlog")
  puma_backlog.update!(unit: "req")
  if puma_backlog.samples.none?
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
