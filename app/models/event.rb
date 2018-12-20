class Event < ApplicationRecord
  validates :name, presence: true
  validates :starts_at, presence: true
  validates :ends_at, presence: true

  belongs_to :event_series, inverse_of: :events
  has_many :user, through: :event_series, inverse_of: :events
end
