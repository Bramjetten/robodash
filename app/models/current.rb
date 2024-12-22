class Current < ActiveSupport::CurrentAttributes
  attribute :dashboard
  attribute :session
  delegate :user, to: :session, allow_nil: true
end
