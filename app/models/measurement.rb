class Measurement < ApplicationRecord
  include Widgetable

  # Using a fixed window after which samples are removed.
  SAMPLE_WINDOW = 1.hour

  has_many :samples, -> { where(timestamp: SAMPLE_WINDOW.ago..).order(timestamp: :asc) }

  def value
    samples.last&.value
  end

  def status
    samples.any? ? :up : :down
  end
end
