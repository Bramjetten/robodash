# Simple job that periodically pings all UptimeMonitors
#
# This should run maybe every 10 minute as well
class UptimeMonitorsJob < ApplicationJob

  def perform
    # Make sure to only ping UptimeMonitors with widgets
    # TODO: make sure we have no orphaned records using the db
    UptimeMonitor.joins(:widget).find_each(&:ping_for_uptime!)
  end

end

