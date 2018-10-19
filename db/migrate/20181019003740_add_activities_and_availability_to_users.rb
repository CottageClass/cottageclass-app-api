class AddActivitiesAndAvailabilityToUsers < ActiveRecord::Migration[5.2]
  def change
    # Rails+Postgres interacts with arrays fairly well: https://blog.sundaycoding.com/blog/2017/01/22/rails-plus-postgres-array-plus-any-like/
    add_column :users, :activities, :text, array: true, default: []
    add_column :users, :available_mornings, :boolean
    add_column :users, :available_afternoons, :boolean
    add_column :users, :available_evenings, :boolean
    add_column :users, :available_weekends, :boolean
    add_column :users, :network_code, :string
  end
end
