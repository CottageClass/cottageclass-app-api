class AddShowcaseEventToUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :showcase_event, foreign_key: true
  end
end
