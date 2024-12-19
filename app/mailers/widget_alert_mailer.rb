class WidgetAlertMailer < ApplicationMailer

  def alert(widget)
    @widget_alert = WidgetAlert.new(widget)
    mail to: @widget.dashboard.email
  end

  def clear(widget)
    @widget_alert = WidgetAlert.new(widget)
    mail to: @widget.dashboard.email
  end

end

