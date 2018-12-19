class CreateEventHosts < ActiveRecord::Migration[5.2]
  def change
    create_table :event_hosts do |t|
      t.string :name, null: false
      t.string :email, :phone
      t.boolean :verified, default: false
      t.json :meta
      t.timestamps null: true
    end

    create_join_table(:event_hosts, :event_series) { |t| t.index(%i[event_host_id event_series_id], unique: true) }
  end
end
