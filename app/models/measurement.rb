class Measurement < ApplicationRecord
  include Widgetable

  has_many :samples, -> { order(timestamp: :asc) }

  def value
    samples.last&.value
  end

  # Samples for the graph: one min/median/max point per bucket, including
  # buckets AggregateSamplesJob hasn't aggregated yet, followed by the latest
  # raw sample so the line ends on the live value.
  def graph_samples(window: 25.hours)
    bucket = AggregateSamplesJob::BUCKET.to_i
    buckets = samples.unscope(:order)
      .where(timestamp: window.ago..)
      .select("datetime((strftime('%s', timestamp) / #{bucket}) * #{bucket}, 'unixepoch') AS timestamp, " \
              "MIN(COALESCE(min, value)) AS min, MEDIAN(value) AS value, MAX(COALESCE(max, value)) AS max")
      .group("strftime('%s', timestamp) / #{bucket}")
      .order(:timestamp)
      .to_a

    latest = samples.last
    latest ? buckets + [ latest ] : buckets
  end

  def status
    samples.any? ? :up : :down
  end
end
