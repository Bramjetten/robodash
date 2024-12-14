# Heartbeats are uptime monitors for bg jobs
# They have a schedule
class Heartbeat < ApplicationRecord
  include Alertable, Widgetable

  SCHEDULE_PERIODS = %w[month week day hour minute]

  # For use in scopes
  PING_EXPECTED_BEFORE_SQL = <<~SQL
    (now() - CAST(schedule_number||' '||schedule_period AS Interval) - CAST(grace_period||' seconds' AS Interval))
  SQL

  # Each heartbeat needs a schedule and grace period
  validates :schedule_period, inclusion: { in: SCHEDULE_PERIODS }
  validates :schedule_number, :grace_period, presence: true, numericality: { greater_than: 0, only_integer: true } 

  scope :down, -> { where("pinged_at < #{PING_EXPECTED_BEFORE_SQL}") }
  scope :up, -> { where("pinged_at >= #{PING_EXPECTED_BEFORE_SQL}") }

  def status
    return :new if pinged_at.blank?
    pinged_at > ping_expected_before ? :up : :down
  end

  # This is the message that is used when something goes wrong
  def alert_message
    "Ping expected before: #{I18n.l(ping_expected_before, format: :long)}"
  end

  private

    # Grace period is in seconds so we can do Robodash.ping("some-widget", grace_period: 30.minutes) in the Ruby gem
    def ping_expected_before
      schedule_number.send(schedule_period).ago - grace_period.seconds
    end

end

