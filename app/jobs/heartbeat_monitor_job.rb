# Very simple job!
# It just checks heartbeats
class HeartbeatMonitorJob < ApplicationJob

  def perform
    # First, alert all non-alerted heartbeats that are down...
    Heartbeat.joins(:widget).merge(Widget.not_alerted).down.find_each(&:alert!)

    # ..then, clear all alerted heartbeats that are up!
    Heartbeat.joins(:widget).merge(Widget.alerted).up.find_each(&:alert!)
  end

end

