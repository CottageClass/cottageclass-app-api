class CreateEventCollections < ActiveRecord::Migration[5.2]
  def change
    create_table :event_collections do |t|

      t.timestamps
    end
  end
end
