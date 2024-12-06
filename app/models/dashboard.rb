class Dashboard < ApplicationRecord
  has_many :widgets, dependent: :destroy

  def down?
    widgets.any?(&:down?)
  end

end

