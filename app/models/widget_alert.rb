# This class is used to notify end users about alerts
#
# Most important methods of this class:
# - WidgetAlert.create(widget)
# - WidgetAlert.destroy(widget)
#
# These class methods return instances of WidgetAlert with 
# a couple of useful methods like #name and #message.
#
# Creating a WidgetAlert results in emails/notifications
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
      widget.transaction do
        widget.touch(:alerted_at)
        WidgetAlertMailer.alert(widget).deliver_later
      end

      new(widget)
    end

    def clear(widget)
      widget.transaction do
        widget.update(alerted_at: nil)
        WidgetAlertMailer.clear(widget).deliver_later
      end

      new(widget)
    end
  end

end
