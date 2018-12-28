class ParticipantChild < ApplicationRecord
  before_validation :cleanup

  belongs_to :participable, polymorphic: true, inverse_of: :participant_children
  belongs_to :participant, inverse_of: :participant_children
  belongs_to :child, inverse_of: :participant_children

  private

  def cleanup
    self.participable = participant.try :participable
  end
end
