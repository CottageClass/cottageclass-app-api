class Device < ApplicationRecord
  enum platform: {
    pwa: 0,
    ios: 1
  }
  belongs_to :user, inverse_of: :devices

  def send_push(data)
    case platform.to_sym
    when :pwa
      push_notification = Rpush::Gcm::Notification.new
      push_notification.app = Rpush::Gcm::App.find_by(name: 'lilypad-firebase')
      push_notification.registration_ids = [token]
      push_notification.data = data
      push_notification.priority = 'high'
      push_notification.content_available = true
      push_notification.save!

    when :ios
      n = Rpush::Apns2::Notification.new
      n.app = Rpush::Apns2::App.find_by name: 'lilypad-ios'
      n.device_token = token
      n.alert = data
      n.data = { headers: { 'apns-topic': ENV['APNS_BUNDLE_ID'] } }
      n.save!
    end
  end
end
