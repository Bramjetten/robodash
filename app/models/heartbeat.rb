class Heartbeat < ApplicationRecord
  include Alertable, Widgetable

  SCHEDULE_PERIODS = %w[month week day hour minute]

  # Destroying the widgetable (Heartbeat) also destroys the widget
  has_one :widget, as: :widgetable, dependent: :destroy

  # Each heartbeat needs a schedule and grace period
  validates :grace_period, presence: true
  validates :schedule_period, inclusion: { in: SCHEDULE_PERIODS }
  validates :schedule_number, numericality: { greater_than: 0, only_integer: true } 

  # Use CAST to calculate expired/OK heartbeats
  # Note: || is used to concatenate values in SQL
  scope :expired, -> { where("pinged_at < now() - CAST(schedule_number||' '||schedule_period AS Interval) - CAST(grace_period||' seconds' AS Interval)") }
  scope :status_ok, -> { where("pinged_at >= now() - CAST(schedule_number||' '||schedule_period AS Interval) - CAST(grace_period||' seconds' AS Interval)") }

  # Just updating the timestamp is enough
  def ping!
    touch(:pinged_at)
  end

  private

    # Grace period is in seconds so we can do Robodash.ping("some-widget", grace_period: 30.minutes) in the Ruby gem
    def ping_expected_before
      schedule_number.send(schedule_period).ago - grace_period.seconds
    end

end

