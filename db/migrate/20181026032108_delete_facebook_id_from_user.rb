class DeleteFacebookIdFromUser < ActiveRecord::Migration[5.2]
  def change
    # redundant with facebook_uid
    remove_column :users, :facebook_id
  end
end
