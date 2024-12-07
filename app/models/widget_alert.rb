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
      widget_alert = new(widget)
      widget.transaction do
        widget.touch(:alerted_at)
        WidgetAlertMailer.alert(widget_alert)
      end

      widget_alert
    end

    def destroy(widget)
      widget_alert = new(widget)
      widget.transaction do
        widget.update(alerted_at: nil)
        WidgetAlertMailer.clear(widget_alert)
      end

      widget_alert
    end
  end

end
