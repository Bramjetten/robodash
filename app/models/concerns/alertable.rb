module Alertable
  extend ActiveSupport::Concern

  included do
    scope :not_alerted, -> { where(alerted_at: nil) }
    scope :alerted, -> { where.not(alerted_at: nil) }

    def alerted?
      alerted_at.present?
    end
  end
end

