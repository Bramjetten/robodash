# This class is used to notify end users about alerts
#
# Most important methods of this class:
# - WidgetAlert.create(widget)
# - WidgetAlert.destroy(widget)
#
# These class methods return instances of WidgetAlert with 
# a couple of useful methods like #name and #message.
#
# Creating a WidgetAlert results in emails/push notifications
# Destroying a WidgetAlert does the same, but with different messages
class WidgetAlert
  attr_reader :widget

  def initialize(widget)
    @widget = widget
  end

  def name
    widget.name
  end
  
  def message
    widget.widgetable.alert_message
  end

  class << self
    def create(widget)
      widget.update!(alerted_at: Time.current)
      widget.status_changes.create!(status: "down")
      widget.dashboard.notification_email_addresses.each do |email_address|
        WidgetAlertMailer.alert(widget, email_address).deliver_later
      end
      push_notification(widget, :down, widget.widgetable.alert_message).deliver_later_to(widget.dashboard.push_devices)

      new(widget)
    end

    def clear(widget)
      widget.update!(alerted_at: nil)
      widget.status_changes.create!(status: "up")
      widget.dashboard.notification_email_addresses.each do |email_address|
        WidgetAlertMailer.clear(widget, email_address).deliver_later
      end
      push_notification(widget, :up, "Back to normal").deliver_later_to(widget.dashboard.push_devices)

      new(widget)
    end

    private

      # content-available wakes the app so it can refresh its widgets right away.
      # APNs would treat that as a background push, so the push type is set explicitly.
      def push_notification(widget, status, message)
        ApplicationPushNotification
          .with_apple(aps: { "content-available": 1 }, "apns-push-type": "alert")
          .with_data(dashboard_id: widget.dashboard_id, widget_id: widget.id, status: status.to_s)
          .new(
            title: "#{widget.name} is #{status}",
            body: "#{widget.dashboard.name}: #{message}",
            thread_id: "dashboard-#{widget.dashboard_id}",
            sound: "default"
          )
      end
  end

end
