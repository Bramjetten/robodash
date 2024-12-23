class Current < ActiveSupport::CurrentAttributes
  attribute :dashboard
  attribute :session
  attribute :account
  delegate :user, to: :session, allow_nil: true
end
