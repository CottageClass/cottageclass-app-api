class ChildcareRequest < ApplicationRecord
  belongs_to :user, inverse_of: :childcare_requests
  after_create :create_search_list_item

  attribute :content

  has_one :search_list_item, as: :itemable, class_name: 'SearchListItem', dependent: :destroy
  has_one :place, through: :user

  def create_search_list_item
    SearchListItem.create(user: user, itemable: self)
  end
end
