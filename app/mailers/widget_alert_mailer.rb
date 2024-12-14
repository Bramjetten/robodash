class WidgetAlertMailer < ApplicationMailer

  def alert(widget_alert)
    @widget_alert = widget_alert
    mail to: @widget_alert.widget.dashboard.email
  end

  def clear(widget_alert)
    @widget_alert = widget_alert
    mail to: @widget_alert.widget.dashboard.email
  end

end

