require "test_helper"

class MeasurementTest < ActiveSupport::TestCase
  test "#value returns the latest value" do
    measurement = measurements(:puma_backlog)
    measurement.samples.create(value: 1, timestamp: 1.minute.ago)
    measurement.samples.create(value: 2, timestamp: 2.minutes.ago)

    assert_equal 1, measurement.value
  end
end
