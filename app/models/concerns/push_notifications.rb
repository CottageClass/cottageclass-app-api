require 'active_support/concern'

module PushNotifications
  extend ActiveSupport::Concern

  included do
    has_many :devices, dependent: :nullify
  end

  def push_to_devices(data)
    devices.each do |d|
      d.send_push(data)
    end
  end

  def push_notify_new_group_chat(comment)
    return unless setting_notify_group_messages_push

    push_to_devices icon: comment.sender.avatar,
                    url: ENV['LINK_HOST'] + '/group-chat/' + comment.group.id.to_s,
                    title: "#{comment.sender.first_name.capitalize} sent a new  message to #{comment.group.name}",
                    body: 'Tap to read the message and respond'
  end

  def push_notify_message_receipt(message)
    return unless setting_notify_messages_push

    push_to_devices icon: message.sender.avatar,
                    url: ENV['LINK_HOST'] + '/chat/' + message.sender.id.to_s,
                    title: "New message from #{message.sender.first_name.capitalize}",
                    body: 'Tap to read the message and respond'
  end

  def push_notify_event_creation(event)
    push_to_devices icon: event.user.avatar,
                    url: ENV['LINK_HOST'] + '/event/' + event.id.to_s,
                    title: "#{event.user.first_name.capitalize} has a new offering",
                    body: event.name
  end
end
