class Participant < ApplicationRecord
  belongs_to :participable, polymorphic: true, inverse_of: :participants
  belongs_to :user, inverse_of: :participants

  scope :next_day, lambda {
    where(Participant.arel_table[:created_at].between(23.hours.since(Time.current)..35.hours.since(Time.current)))
      .order starts_at: :asc
  }

  delegate(*User::PUBLIC_ATTRIBUTES, to: :user, prefix: true, allow_nil: true)

  after_create :notify

  def notify
    participable.notifications.participant_creation.where(recipient: user).first_or_create if user.id != participable.user.id
    if user.id != participable.user.id
      participable.notifications.participant_creation_host.where(recipient: participable.user, notifiable: self)
        .first_or_create participant: self
    end
  end
end
