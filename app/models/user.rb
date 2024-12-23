class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  has_many :memberships, dependent: :destroy
  has_many :accounts, through: :memberships

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  # Get all dashboards that are connected to the accounts of this user (memoized)
  def dashboards
    @dashboards ||= Dashboard.joins(:account).where(account: accounts)
  end

end
