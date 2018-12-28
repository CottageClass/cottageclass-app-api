class Child < ApplicationRecord
  validates :first_name, presence: true
  validates :birthday, presence: true

  belongs_to :parent, class_name: 'User', inverse_of: :children
  has_many :participant_children, inverse_of: :child, dependent: :destroy

  alias_attribute :user_id, :parent_id
  alias_attribute :name, :first_name

  def age
    ((Time.current - birthday.in_time_zone) / 1.year.seconds).floor
  end
end
