# TODO: parse response_code with string (like OK, Not Found, etc.)
# TODO: make it so that this needs to be verified twice
# TODO: different way to detect down/up, add status :pending
class UptimeMonitor < ApplicationRecord
  include Alertable, Widgetable

  scope :down, -> { where.not(response_code: 200) }
  scope :up, -> { where(response_code: 200) }

  validates :url, presence: true

  def status
    return :up if response_ok?
    :down
  end

  def warning?
    response_time.to_i > 500
  end

  def alert_message
    # TODO: Better alert message
    "URL could not be reached"
  end

  def ping_for_uptime!
    response = ping_url!
    update(response_code: response[:response].code, response_time: response[:time])
  rescue
    update(response_code: nil, response_time: nil)
  end

  private

    def response_ok?
      response_code == 200
    end

    def ping_url!
      t1 = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      response = HTTParty.get(url, {timeout: 10})
      t2 = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      delta = (t2 - t1) * 1000
      {response: response, time: delta.to_i}
    end

end

