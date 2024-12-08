# Very simple job!
# It just checks heartbeats
class HeartbeatMonitorJob < ApplicationJob

  def perform
    # First, alert all non-alerted heartbeats that are down...
    Heartbeat.not_alerted.down.find_each(&:alert!)
    Counter.not_alerted.down.find_each(&:alert!)

    # ..then, clear all alerted heartbeats that are up!
    Heartbeat.alerted.up.find_each(&:clear_alert!)
    Counter.alerted.up.find_each(&:clear_alert!)
  end

end

