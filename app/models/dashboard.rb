class Dashboard < ApplicationRecord
  has_many :widgets, dependent: :destroy

  belongs_to :account

  # You fetch a dashboard using a secure token
  has_secure_token :token

  # TODO: replace this with notification channels
  def email
    "mail@bramjetten.nl"
  end

  # A dashboard is down if any of its widgets are down
  # This is not cached and potentially quite slow
  #
  # Could be more efficient, but would require knowledge 
  # of all existing widgetables. Not great design.
  def down?
    widgets.any?(&:down?)
  end

end

