# Very simple job!
# It sends and clears alerts
# TODO: Only check heartbeats here
# TODO: Make counters and uptimemonitors alert and clear alerts when they actually updated
class AlertsJob < ApplicationJob

  def perform
    # First, alert all non-alerted widgets that are down...
    Heartbeat.not_alerted.down.find_each(&:alert!)
    Counter.not_alerted.down.find_each(&:alert!)
    UptimeMonitor.not_alerted.down.find_each(&:alert!)

    # ..then, clear all alerted widgets that are up!
    Heartbeat.alerted.up.find_each(&:clear_alert!)
    Counter.alerted.up.find_each(&:clear_alert!)
    UptimeMonitor.alerted.up.find_each(&:clear_alert!)
  end

end

