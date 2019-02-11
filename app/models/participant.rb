class Participant < ApplicationRecord
  validates_associated :participant_children
  validate do |instance|
    instance.errors.add :base, :invalid, message: 'must have at least one child' if instance.participant_children.blank?
    if instance.participable.present? &&
       instance.participable.maximum_children.positive? && (
        instance.participable.participant_children.size + instance.participant_children.size
      ) > instance.participable.maximum_children
      instance.errors.add(:base, :invalid, message: 'exceeds maximum number of children')
    end
  end

  belongs_to :participable, polymorphic: true, inverse_of: :participants
  belongs_to :user, inverse_of: :participants
  has_many :participant_children, inverse_of: :participant, dependent: :destroy

  scope :next_day, lambda {
    where(Participant.arel_table[:created_at].between(23.hours.since(Time.current)..35.hours.since(Time.current)))
      .order starts_at: :asc
  }

  delegate :facebook_uid, :avatar, :first_name, :fuzzy_latitude, :fuzzy_longitude, :locality, :sublocality,
           :neighborhood, :admin_area_level_1, :admin_area_level_2, :child_ages, :verified,
           to: :user, prefix: true, allow_nil: true

  accepts_nested_attributes_for :participant_children,
                                allow_destroy: true,
                                reject_if: proc { |attributes| attributes['child_id'].blank? }

  after_create :notify

  def notify
    participable.notifications.participant_creation.where(recipient: user).first_or_create
    participable.notifications.participant_creation_host.where(recipient: participable.user)
      .first_or_create participant: self
  end

  def next_day_notify
    if (Time.current >= 1.day.since(created_at)) && (1.day.since(created_at) < participable.starts_at)
      participable.notifications.participant_creation_next_day.where(recipient: user).first_or_create
    end
  end
end
