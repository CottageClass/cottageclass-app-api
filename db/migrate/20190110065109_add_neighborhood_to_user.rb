class AddNeighborhoodToUser < ActiveRecord::Migration[5.2]
  def up
    new_columns.each { |column| add_column(:users, column, :string) unless column_exists?(:users, column) }
  end

  def down
    new_columns.each { |column| remove_column(:users, column) if column_exists?(:users, column) }
  end

  def new_columns
    %i[neighborhood sublocality]
  end
end
