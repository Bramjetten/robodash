# Simple job that periodically pings all UptimeMonitors
class UptimeMonitorsJob < ApplicationJob

  def perform
    UptimeMonitor.all.find_each(&:ping_for_uptime!)
  end

end

