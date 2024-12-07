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

  def alert!
    touch(:alerted_at)
    # Send a notification!
  end

  def clear_alert!
    update(alerted_at: nil)
    # Send a notification!
  end

  def alerted?
    alerted_at.present?
  end

end

