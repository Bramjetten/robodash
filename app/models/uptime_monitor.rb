# TODO: warning light
# TODO: stale after hour of no monitoring
class UptimeMonitor < ApplicationRecord
  include Widgetable

  scope :down, -> { where.not(response_code: 200) }
  scope :up, -> { where(response_code: 200) }

  validates :url, presence: true

  def status
    return :up if response_ok?
    :down
  end

  def alert_message
    # TODO: Better alert message
    "URL could not be reached"
  end

  private

    def response_ok?
      response_code == 200
    end

end

