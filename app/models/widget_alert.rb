class WidgetAlert
  attr_reader :widget

  def initialize(widget)
    @widget = widget
  end
  
  def message
    "Something went wrong with #{widget.name}: #{widget.widgetable.alert_message}"
  end

  class << self
    def create(widget)
      widget.touch(:alerted_at)
      new(widget)
    end

    def destroy(widget)
      widget.update(alerted_at: nil)
      new(widget)
    end
  end

end
