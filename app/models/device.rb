class Device < ApplicationRecord
  belongs_to :user, inverse_of: :devices
end