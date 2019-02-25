class AddPausedFromToEventSeries < ActiveRecord::Migration[5.2]
  def up
    columns.each { |column| add_column(:event_series, column, :date) unless column_exists?(:event_series, column) }
    add_column(:events, :kind, :integer, default: 0) unless column_exists?(:events, :kind)
  end

  def down
    remove_column(:events, :kind) if column_exists?(:events, :kind)
    columns.each { |column| remove_column(:event_series, column) if column_exists?(:event_series, column) }
  end

  def columns
    %i[paused_from paused_until]
  end
end
