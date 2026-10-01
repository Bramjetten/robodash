# Widgets a user starred, shown at the top of a dashboard in the iOS app
class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :widget

  validates :widget_id, uniqueness: { scope: :user_id }
end
