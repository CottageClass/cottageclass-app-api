class Child < ApplicationRecord
  validates :first_name, presence: true
  validates :birthday, presence: true

  belongs_to :parent, class_name: 'User', inverse_of: :children

  alias_attribute :user_id, :parent_id
  alias_attribute :name, :first_name

  def age
    ((Time.current - birthday.in_time_zone) / 1.year.seconds).floor
  end

  def age_in_months
    (Time.current.year - birthday.year) * 12 +
      Time.current.month - birthday.month -
      (Time.current.day < birthday.day ? 1 : 0)
  end
end
