class Child < ApplicationRecord
  belongs_to :parent, class_name: 'User', foreign_key: :user_id, inverse_of: :children
  alias_attribute :parent_id, :user_id

  validates :first_name, presence: true
  validates :birthday, presence: true
end
