# Counters are monitors for all kinds of things
# They can have a minimum or maximum value
class Counter < ApplicationRecord
  include Widgetable

  def status
    :new
  end

  # This is the message that is used when something goes wrong
  def alert_message
    "#{ping_expected_before}"
  end
end

