class ParticipantChild < ApplicationRecord
  before_validation :cleanup
  validate do |instance|
    if instance.user.present? && instance.user.children.exclude?(instance.child)
      instance.errors.add(:child_id, :invalid)
    end
  end

  belongs_to :participable, polymorphic: true, inverse_of: :participant_children
  belongs_to :participant, inverse_of: :participant_children
  belongs_to :child, inverse_of: :participant_children

  delegate :user, to: :participant, allow_nil: true
  delegate :name, :age, to: :child, prefix: true, allow_nil: true

  private

  def cleanup
    self.participable = participant.try :participable
  end
end
