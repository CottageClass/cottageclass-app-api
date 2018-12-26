class AddFacebookTokenToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :facebook_access_token, :string
    add_column :users, :fb_access_token_expires_at, :datetime, default: -> { 'CURRENT_TIMESTAMP' }
  end
end
