class AddFuzzyLatitudeToUser < ActiveRecord::Migration[5.2]
  def up
    modified_columns.each do |column|
      next if column_exists?(:users, column, :decimal)

      temporary_column = format 'temporary_%s', column
      remove_column(:users, temporary_column) if column_exists?(:users, temporary_column)
      add_column :users, temporary_column, :decimal
      User.reset_column_information
      User.find_each do |user|
        current_value = user.send column
        if current_value.present?
          current_value = current_value.to_f
          if current_value != 0
            user.update_column temporary_column, current_value
            user.reload
            raise 'did not update' unless current_value.eql?(user.send(temporary_column).to_f)
          end
        end
      end
      remove_column :users, column
      rename_column :users, temporary_column, column
    end
    new_columns.each { |column| add_column(:users, column, :decimal) unless column_exists?(:users, column) }
    add_index(:users, modified_columns) unless index_exists?(:users, modified_columns)
    add_index(:users, new_columns) unless index_exists?(:users, new_columns)
  end

  def down
    remove_index(:users, new_columns) if index_exists?(:users, new_columns)
    new_columns.each { |column| remove_column(:users, column) if column_exists?(:users, column) }
    remove_index(:users, modified_columns) if index_exists?(:users, modified_columns)
    modified_columns.each { |column| change_column :users, column, :string }
  end

  def modified_columns
    %i[latitude longitude]
  end

  def new_columns
    %i[fuzzy_latitude fuzzy_longitude]
  end
end
