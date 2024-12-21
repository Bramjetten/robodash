class WidgetAlertMailer < ApplicationMailer

  def alert(widget)
    @widget_alert = WidgetAlert.new(widget)
    mail to: widget.dashboard.email, subject: t(".subject", dashboard: widget.dashboard.name, widget: widget.name)
  end

  def clear(widget)
    @widget_alert = WidgetAlert.new(widget)
    mail to: widget.dashboard.email, subject: t(".subject", dashboard: widget.dashboard.name, widget: widget.name)
  end

end

