module Widgetable
  extend ActiveSupport::Concern

  included do
    # Destroying the widgetable (Heartbeat) also destroys the widget
    has_one :widget, as: :widgetable, dependent: :destroy

    # Delegate alert methods to widget for easy access
    delegate :alert!, :clear!, to: :widget

    # The widgetable itself itsn't actually alerted, but the widget
    # these scopes make it easy to do things like Heartbeat.alerted.up (to fetch heartbeats that are up and alerted)
    scope :not_alerted, -> { joins(:widget).merge(Widget.not_alerted) }
    scope :alerted, -> { joins(:widget).merge(Widget.alerted) }
  end

  class_methods do
    def find_by_name!(widget_name)
      raise "Current.dashboard must be set before calling this method" unless Current.dashboard
      Current.dashboard.widgets.where(widgetable_type: name).find_by!(name: widget_name).widgetable
    end
  end

  # Each widgetable must implement this method and return
  # :new, :up or :down
  def status
    raise NotImplementedError, "#{self.class} must implement #status"
  end

  def alert_message
    raise NotImplementedError, "#{self.class} must implement #alert_message"
  end

  def new?
    status == :new
  end

  def up?
    status == :up
  end

  def down?
    status == :down
  end

end

