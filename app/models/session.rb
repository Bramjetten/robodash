class Session < ApplicationRecord
  belongs_to :user

  # Devices (iOS app) that receive push notifications for this session,
  # signing out removes them
  has_many :push_devices, class_name: "ApplicationPushDevice", as: :owner, dependent: :destroy
end
