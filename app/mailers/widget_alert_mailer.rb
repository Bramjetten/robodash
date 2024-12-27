class WidgetAlertMailer < ApplicationMailer

  def alert(widget, email_address)
    @widget_alert = WidgetAlert.new(widget)
    mail to: email_address, subject: t(".subject", dashboard: widget.dashboard.name, widget: widget.name)
  end

  def clear(widget, email_address)
    @widget_alert = WidgetAlert.new(widget)
    mail to: email_address, subject: t(".subject", dashboard: widget.dashboard.name, widget: widget.name)
  end

end

