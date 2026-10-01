class ApplicationPushNotification < ActionPushNative::Notification
  # Controls whether push notifications are enabled (default: !Rails.env.test?)
  # Skipped when no APNs key is configured (e.g. in development)
  self.enabled = !Rails.env.test? && Rails.application.credentials.dig(:action_push_native, :apns, :key_id).present?
end
