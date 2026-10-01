require "test_helper"

class WidgetAlertTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  setup do
    @widget = dashboards(:plango).widgets.create!(name: "Failed jobs", widgetable: Counter.new(count: 0))
    @device = users(:nick).sessions.create!.push_devices.create!(token: "abc123", platform: "apple")
  end

  test "should push to the devices of the account when a widget goes down" do
    assert_enqueued_with(job: ApplicationPushNotificationJob, args: ->(args) { push_args(args, "down") }) do
      WidgetAlert.create(@widget)
    end
  end

  test "should push to the devices of the account when a widget is back up" do
    assert_enqueued_with(job: ApplicationPushNotificationJob, args: ->(args) { push_args(args, "up") }) do
      WidgetAlert.clear(@widget)
    end
  end

  test "should not push to devices of other accounts" do
    other_user = User.create!(email_address: "other@example.com", password: "password")
    other_user.sessions.create!.push_devices.create!(token: "other", platform: "apple")

    assert_enqueued_jobs 1, only: ApplicationPushNotificationJob do
      WidgetAlert.create(@widget)
    end
  end

  private

    def push_args((notification_class, attributes, device), status)
      notification_class == "ApplicationPushNotification" &&
        device == @device &&
        attributes[:title] == "Failed jobs is #{status}" &&
        attributes[:data] == { dashboard_id: @widget.dashboard_id, widget_id: @widget.id, status: } &&
        attributes.dig(:apple_data, :"apns-push-type") == "alert"
    end
end
