class Dashboard < ApplicationRecord
  has_many :widgets, dependent: :destroy

  belongs_to :account

  # You fetch a dashboard using a secure token
  has_secure_token :token

  # TODO: Replace with notification channels later (so we can do Slack/Basecamp/Email/Push/etc.)
  # Perhaps with notified gem. Or ActionNotifier?
  def notification_email_addresses
    account.users.pluck(:email_address).uniq
  end

  # Signed in iOS apps of everyone in the account
  def push_devices
    ApplicationPushDevice.where(owner: Session.where(user: account.users))
  end

  # A dashboard is down if any of its widgets are down
  def down?
    widgets.down.exists?
  end

end

