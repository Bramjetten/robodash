# Heartbeats are uptime monitors for bg jobs
# They have a schedule
class Heartbeat < ApplicationRecord
  include Widgetable

  SCHEDULE_PERIODS = %w[month week day hour minute]

  # For use in scopes
  PING_EXPECTED_BEFORE_SQL = <<~SQL
    (now() - CAST(heartbeats.schedule_number||' '||heartbeats.schedule_period AS Interval) - CAST(heartbeats.grace_period||' seconds' AS Interval))
  SQL

  # Each heartbeat needs a schedule and grace period
  validates :grace_period, presence: true
  validates :schedule_period, inclusion: { in: SCHEDULE_PERIODS }
  validates :schedule_number, numericality: { greater_than: 0, only_integer: true } 

  scope :down, -> { where("heartbeats.pinged_at < #{PING_EXPECTED_BEFORE_SQL}") }
  scope :up, -> { where("heartbeats.pinged_at >= #{PING_EXPECTED_BEFORE_SQL}") }

  # Just updating the timestamp is enough
  def ping!
    touch(:pinged_at)
  end

  def status
    return :new if pinged_at.blank?
    pinged_at > ping_expected_before ? :up : :down
  end

  private

    # Grace period is in seconds so we can do Robodash.ping("some-widget", grace_period: 30.minutes) in the Ruby gem
    def ping_expected_before
      schedule_number.send(schedule_period).ago - grace_period.seconds
    end

end

