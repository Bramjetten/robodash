# Widgets!
#
# The widgetable is the thing that actually tracks uptime
# - Heartbeat
# - Counter
# - UptimeMonitor
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
  delegate :status, :new?, :up?, :down?, :warning?, to: :widgetable

  def alerted?
    alerted_at.present?
  end

  def not_alerted?
    alerted_at.blank?
  end

  # These objects send emails and notifications
  # They are not persisted
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

