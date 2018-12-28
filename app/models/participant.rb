class Participant < ApplicationRecord
  belongs_to :participable, polymorphic: true, inverse_of: :participants
  belongs_to :user, inverse_of: :participants
  has_many :participant_children, inverse_of: :participant, dependent: :destroy

  accepts_nested_attributes_for :participant_children,
                                allow_destroy: true,
                                reject_if: proc { |attributes| attributes['child_id'].blank? }
end
