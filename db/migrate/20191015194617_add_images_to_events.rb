class AddImagesToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :images, :text, array: true, default: []
  end
end
