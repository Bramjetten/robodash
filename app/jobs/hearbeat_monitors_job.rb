# Very simple job!
# It sends and clears alerts for heartbeats
#
# This should run every 10 minutes or so
class HeartbeatMonitorsJob < ApplicationJob

  def perform
    # First, alert all non-alerted heartbeats that are down...
    Heartbeat.not_alerted.down.find_each(&:alert!)

    # ..then, clear all alerted heartbeats that are up!
    Heartbeat.alerted.up.find_each(&:clear_alert!)
  end

end

