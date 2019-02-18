class AddSourceTagsToUser < ActiveRecord::Migration[5.2]
  def up
    add_column(:users, :source_tags, :text, array: true, default: []) unless column_exists?(:users, :source_tags)
    add_column(:users, :referrer, :string) unless column_exists?(:users, :referrer)
  end

  def down
    add_column(:users, :referrer) if column_exists?(:users, :referrer)
    add_column(:users, :source_tags) if column_exists?(:users, :source_tags)
  end
end
