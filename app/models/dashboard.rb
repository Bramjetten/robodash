class Dashboard < ApplicationRecord
  has_many :widgets, dependent: :destroy

  has_secure_token :token

  def down?
    widgets.any?(&:down?)
  end

end

