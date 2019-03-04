class AddDeviseToUsers < ActiveRecord::Migration[5.2]
  def change
    change_table :users, bulk: true do |t|
      # Database authenticatable
      t.string :encrypted_password, null: false, default: ''

      # Recoverable
      t.string :reset_password_token
      t.datetime :reset_password_sent_at

      # Rememberable
      t.datetime :remember_created_at

      # Trackable
      t.integer :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at, :last_sign_in_at
      t.string :current_sign_in_ip, :last_sign_in_ip

      # Confirmable
      t.string :confirmation_token, :unconfirmed_email # Only if using reconfirmable
      t.datetime :confirmed_at, :confirmation_sent_at

      # Lockable
      t.integer :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      t.string :unlock_token # Only if unlock strategy is :email or :both
      t.datetime :locked_at

      # Invitable
      t.references :invited_by, polymorphic: true, index: true
      t.string :invitation_token
      t.datetime :invitation_created_at, :invitation_sent_at, :invitation_accepted_at
      t.integer :invitation_limit
      t.integer :invitations_count, default: 0

      # OmniAuth
      t.string :provider, :uid

      # Custom
      t.boolean :terms_of_service, null: false, default: false

      t.index :email
      t.index :reset_password_token, unique: true
      t.index :confirmation_token, unique: true
      t.index :unlock_token, unique: true
      t.index :invitation_token, unique: true
      t.index :invitations_count
      t.index %i[provider uid]
    end

    reversible do |direction|
      direction.up do
        change_column_default :users, :encrypted_password, nil
        change_column_null :users, :email, false
        remove_column :users, :password_digest
      end
      direction.down do
        add_column :users, :password_digest, :string
        change_column_null :users, :email, true
      end
    end
  end
end
