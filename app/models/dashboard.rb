class Dashboard < ApplicationRecord
  has_many :widgets, dependent: :destroy

  # You fetch a dashboard using a secure token
  has_secure_token :token

  # A dashboard is down if any of its widgets are down
  def down?
    widgets.any?(&:down?)
  end

end

