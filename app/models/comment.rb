class Comment < ApplicationRecord
  after_create :notify

  has_many :notifications, as: :notifiable, dependent: :nullify

  belongs_to :group,
             inverse_of: :comments,
             class_name: 'UserGroup',
             foreign_key: :group_id
  belongs_to :sender,
             inverse_of: :comments,
             class_name: 'User',
             foreign_key: :sender_id

  scope :recent, -> { where('created_at > ?', 48.hours.ago(Time.current)).order(created_at: :desc) }

  def notify
    group.members.includes(:place).each do |m|
      m.notifications.new_group_message.create notifiable: self unless m == sender
      m.push_notify_new_group_chat self
    end
  end
end
