class Dashboard < ApplicationRecord
  has_many :widgets, dependent: :destroy
end

