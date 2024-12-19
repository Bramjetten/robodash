module Alertable
  extend ActiveSupport::Concern

  included do
    after_save_commit :alert!, if: -> { down? && widget.not_alerted? }
    after_save_commit :clear_alert!, if: -> { up? && widget.alerted? }

    # Delegate alert methods to widget for easy access
    delegate :alert!, :clear_alert!, to: :widget

    # The widgetable itself itsn't actually alerted, but the widget
    # these scopes make it easy to do things like Heartbeat.alerted.up (to fetch heartbeats that are up and alerted)
    scope :not_alerted, -> { joins(:widget).merge(Widget.not_alerted) }
    scope :alerted, -> { joins(:widget).merge(Widget.alerted) }
  end

  def alert_message
    raise NotImplementedError, "#{self.class} must implement #alert_message"
  end

end

