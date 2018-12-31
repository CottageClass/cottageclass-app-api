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

  accepts_nested_attributes_for :participant_children,
                                allow_destroy: true,
                                reject_if: proc { |attributes| attributes['child_id'].blank? }
end
