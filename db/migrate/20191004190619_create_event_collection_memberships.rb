class CreateEventCollectionMemberships < ActiveRecord::Migration[5.2]
  def change
    create_table :event_collection_memberships do |t|
      t.references :event, foreign_key: true
      t.references :event_collection, foreign_key: true

      t.timestamps
    end
  end
end
