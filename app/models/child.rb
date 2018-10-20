class Child < ApplicationRecord
  belongs_to :parent, class_name: 'User', foreign_key: :parent_id, inverse_of: :children
  alias_attribute :user_id, :parent_id

  validates :first_name, presence: true
  validates :birthday, presence: true
end
