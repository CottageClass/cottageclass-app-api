class EventHost < ApplicationRecord
  validates :name, presence: true

  has_and_belongs_to_many :event_series

  before_validation :cleanup

  private

  def cleanup
    self.name = name.try :squish
    self.email = email.try :squish
    self.phone = phone.try :squish
  end
end
