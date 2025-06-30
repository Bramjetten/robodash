# Widgets!
#
# The widgetable is the thing that actually tracks uptime
# - Heartbeat
# - Counter
# - UptimeMonitor
class Widget < ApplicationRecord
  belongs_to :dashboard
  delegated_type :widgetable, types: %w[Heartbeat Counter UptimeMonitor], dependent: :destroy
  
  accepts_nested_attributes_for :widgetable

  # Refresh a dashboard if anything changes
  broadcasts_refreshes_to :dashboard

  scope :not_alerted, -> { where(alerted_at: nil) }
  scope :alerted, -> { where.not(alerted_at: nil) }

  # Uniq validation:
  # There can only be one widget with the same name and type in a dashboard
  validates :name, presence: true, uniqueness: {scope: [:dashboard_id, :widgetable_type]}

  # Delegate status methods to the widgetable
  delegate :status, :up?, :down?, :new?, :warning?, to: :widgetable

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
    WidgetAlert.clear(self)
  end

  def alerted?
    alerted_at.present?
  end

end

