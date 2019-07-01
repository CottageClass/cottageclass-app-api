class SearchListItem < ApplicationRecord
  belongs_to :user, inverse_of: :search_list_items
  belongs_to :itemable, polymorphic: true, inverse_of: :search_list_item, optional: true

  validates :user, presence: true
  validates :itemable_type,
            uniqueness: { scope: %i[itemable_id] },
            allow_nil: true,
            if: -> { itemable.present? }
end
