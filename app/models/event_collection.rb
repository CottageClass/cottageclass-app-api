class EventCollection < ApplicationRecord
  has_many :event_collection_memberships, dependent: :nullify
  has_many :events, through: :event_collection_memberships
  has_many :notifications, as: :notifiable, dependent: :nullify
end
