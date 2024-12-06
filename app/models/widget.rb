class Widget < ApplicationRecord
  belongs_to :dashboard
  belongs_to :widgetable, polymorphic: true

  # Scopes for different types of widgets
  scope :heartbeats, -> { where(widgetable_type: "Heartbeat") }

  # Uniq validation:
  # There can only be one widget with the same name and type in a dashboard
  validates :name, presence: true, uniqueness: {scope: [:dashboard_id, :widgetable_type]}

  # Delegate status methods to the widgetable
  delegate :status, :new, :up, :down, to: :widgetable
end

