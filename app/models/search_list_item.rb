class SearchListItem < ApplicationRecord
  reverse_geocoded_by 'users.place.latitude', 'users.place.longitude'
  user_attributes = User::PUBLIC_ATTRIBUTES.reject { |a| a == :id }
  delegate(*user_attributes, to: :user, allow_nil: true)

  belongs_to :user, inverse_of: :search_list_items
  belongs_to :itemable, polymorphic: true, inverse_of: :search_list_item, optional: true

  validates :user, presence: true
  validates :itemable_id,
            uniqueness: { scope: %i[itemable_type] },
            allow_nil: true,
            if: -> { itemable.present? }

  scope :child_age_range, lambda { |min_age, max_age|
    joins(:user).merge(User.child_age_range(min_age, max_age))
  }
end
