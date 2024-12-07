# The widget class contains the unique name of a widget
# and manages alerts/notifications
#
# The widgetable is the thing that actually tracks uptime
# - Heartbeat
# - TODO: Counter
# - TODO: UptimeMonitor
class Widget < ApplicationRecord
  belongs_to :dashboard
  belongs_to :widgetable, polymorphic: true

  # Scopes for different types of widgets
  scope :heartbeats, -> { where(widgetable_type: "Heartbeat") }

  scope :not_alerted, -> { where(alerted_at: nil) }
  scope :alerted, -> { where.not(alerted_at: nil) }

  # Uniq validation:
  # There can only be one widget with the same name and type in a dashboard
  validates :name, presence: true, uniqueness: {scope: [:dashboard_id, :widgetable_type]}

  # Delegate status methods to the widgetable
  delegate :status, :new, :up, :down, to: :widgetable

  # Simple JSON for the response in the API
  def to_json
    { name: name, status: status }
  end

  # Returns a WidgetAlert object with some useful methods (like .message)
  # this is used by things like the WidgetAlertMailer to send notifications/emails
  def alert!
    WidgetAlert.create(self)
  end

  def clear_alert!
    WidgetAlert.destroy(self)
  end

  def alerted?
    alerted_at.present?
  end

end

