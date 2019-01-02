class AddTimeZoneToEventSeries < ActiveRecord::Migration[5.2]
  def up
    tables.each { |table| add_column(table, :time_zone, :string) unless column_exists?(table, :time_zone) }
  end

  def down
    tables.each { |table| remove_column(table, :time_zone) if column_exists?(table, :time_zone) }
  end

  def tables
    %i[users event_series events]
  end
end
