class Child < ApplicationRecord
  belongs_to :parent, class_name: 'User', inverse_of: :children
  alias_attribute :user_id, :parent_id
  alias_attribute :name, :first_name

  validates :first_name, presence: true
  validates :birthday, presence: true

  def age
    ((Time.current - birthday.in_time_zone) / 1.year.seconds).floor
  end
end
