class AddContentToPlaces < ActiveRecord::Migration[5.2]
  def change
    add_column :places, :description, :text
    add_column :places, :images, :string, array: true, default: []
  end
end
