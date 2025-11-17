class Measurement < ApplicationRecord
  include Widgetable

  has_many :samples, -> { order(timestamp: :asc) }

  def value
    samples.last&.value
  end

  def status
    samples.any? ? :up : :down
  end
end
