class AddApartmentNumberToUser < ActiveRecord::Migration[5.2]
  def up
    add_column(:users, :apartment_number, :string) unless column_exists?(:users, :apartment_number)
  end

  def down
    remove_column(:users, :apartment_number) if column_exists?(:users, :apartment_number)
  end
end
