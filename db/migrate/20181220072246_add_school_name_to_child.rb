class AddSchoolNameToChild < ActiveRecord::Migration[5.2]
  def change
    add_column :children, :school_name, :string
  end
end
