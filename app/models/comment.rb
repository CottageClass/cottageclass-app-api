class Comment < ApplicationRecord
  belongs_to :group,
             inverse_of: :comments,
             class_name: 'UserGroup',
             foreign_key: :group_id
  belongs_to :sender,
             inverse_of: :comments,
             class_name: 'User',
             foreign_key: :sender_id
end
