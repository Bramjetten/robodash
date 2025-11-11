class Sample < ApplicationRecord
  belongs_to :measurement, touch: true

  before_save do
    self.timestamp ||= Time.current
  end
end
