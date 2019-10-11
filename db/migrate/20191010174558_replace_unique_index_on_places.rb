class ReplaceUniqueIndexOnPlaces < ActiveRecord::Migration[5.2]
  def change
    remove_index :places,
                 name: :index_places_on_google_id,
                 column: %i[google_id]
    add_index :places,
              %i[google_id apartment_number],
              name: 'index_places_google_id_apartment_number',
              unique: true
  end
end
