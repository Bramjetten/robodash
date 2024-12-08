# Counters are monitors for numbers
# They can have a minimum or maximum value (optional)
class Counter < ApplicationRecord
  include Widgetable

  scope :down, -> { where("(min IS NOT NULL AND count < min) OR (max IS NOT NULL AND count > max)") }
  scope :up, -> { where("(min IS NULL OR count >= min) AND (max IS NULL OR count <= max)") }

  def status
    return :down if too_low? || too_high?
    :up
  end

  def alert_message
    return "Count is too low" if too_low?
    return "Count is too high" if too_high?
  end
  
  private

    def too_low?
      return false if min.blank?
      count < min
    end

    def too_high?
      return false if max.blank?
      count > max
    end

end

