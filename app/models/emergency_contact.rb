class EmergencyContact < ApplicationRecord
  validates :name, presence: true
  validates :phone_number, presence: true
  validates :relationship, presence: true

  belongs_to :contactable, polymorphic: true, inverse_of: :emergency_contacts
end
