class SearchListItem < ApplicationRecord
  reverse_geocoded_by 'users.latitude', 'users.longitude'

  delegate(*User::PUBLIC_ATTRIBUTES, to: :user, allow_nil: true)

  belongs_to :user, inverse_of: :search_list_items
  belongs_to :itemable, polymorphic: true, inverse_of: :search_list_item, optional: true

  validates :user, presence: true
  validates :itemable_id,
            uniqueness: { scope: %i[itemable_type] },
            allow_nil: true,
            if: -> { itemable.present? }
end
