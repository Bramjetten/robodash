class WidgetAlertMailerPreview < ActionMailer::Preview

  def alert
    widget = Widget.alerted.first
    WidgetAlertMailer.alert(widget)
  end

  def clear
    widget = Widget.not_alerted.first
    WidgetAlertMailer.clear(widget)
  end

end
