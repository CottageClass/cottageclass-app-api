class EventCollectionMembership < ApplicationRecord
  belongs_to :event
  belongs_to :event_collection
end
