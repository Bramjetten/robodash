module Widgetable
  extend ActiveSupport::Concern

  included do
    # Destroying the widgetable (Heartbeat) also destroys the widget
    has_one :widget, as: :widgetable, dependent: :destroy
  end

  # Each widgetable must implement this method and return
  # :new, :up or :down
  def status
    raise NotImplementedError, "#{self.class} must implement #status"
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

