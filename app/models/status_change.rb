# When a widget went down or came back up (recorded with its alerts)
class StatusChange < ApplicationRecord
  RETENTION = 30.days

  belongs_to :widget

  validates :status, inclusion: { in: %w[ up down ] }
end
