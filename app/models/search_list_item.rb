class SearchListItem < ApplicationRecord
  belongs_to :user, inverse_of: :search_list_items
  belongs_to :itemable, polymorphic: true, inverse_of: :search_list_item

  validates :user, presence: true
end
