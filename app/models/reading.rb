# One point in the history of a widget (see Widget#readings):
# - UptimeMonitor: a check, with the response time as value and the HTTP code
# - Heartbeat: a ping
# - Counter: a new count as value
#
# Measurements keep their own history in samples.
class Reading < ApplicationRecord
  belongs_to :widget

  # Uptime checks run every minute, so they're kept short. Pings can be a day apart.
  RETENTION = { "Heartbeat" => 30.days }
  DEFAULT_RETENTION = 25.hours

  def self.retention_for(widget)
    RETENTION.fetch(widget.widgetable_type, DEFAULT_RETENTION)
  end
end
