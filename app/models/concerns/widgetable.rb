module Widgetable
  extend ActiveSupport::Concern

  included do
    has_one :widget, as: :widgetable, dependent: :destroy, touch: true

    scope :with_widget, -> (attributes) { joins(:widget).where(widget: attributes) }
  end

  class_methods do
    # Find or create the widgetable by widget_name
    # This tries to find the widget based on the name first
    # if that fails, try to create a new widget with a widgetable
    # Widgetables should have sane defaults, so validations don't fail here
    #
    # This is great because this way you don't have to setup widgets
    # before using them.
    def find_or_create_by_name!(widget_name)
      raise "Current.dashboard must be set before calling this method" unless Current.dashboard
      Current.dashboard.widgets.where(widgetable_type: name).find_by!(name: widget_name).widgetable
    rescue ActiveRecord::RecordNotFound
      Current.dashboard.widgets.create!(name: widget_name, widgetable: new).widgetable
    end
  end

  # Each widgetable must implement this method and return
  # :new, :up or :down
  def status
    raise NotImplementedError, "#{self.class} must implement #status"
  end

  # Widgets can optionally have a #warning? method
  # By default, widgets return false
  # Example: UptimeMonitors return warning? == true if the response time is high
  #
  # Warnings don't trigger alerts, but can be shown in the UI
  def warning?
    false
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

