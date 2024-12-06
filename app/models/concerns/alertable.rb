module Alertable
  extend ActiveSupport::Concern

  included do
    scope :not_alerted, -> { where(alerted_at: nil) }
    scope :alerted, -> { where.not(alerted_at: nil) }
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

