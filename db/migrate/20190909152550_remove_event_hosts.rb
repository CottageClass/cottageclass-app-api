class RemoveEventHosts < ActiveRecord::Migration[5.2]
  def change
    drop_table :event_hosts
    drop_table :event_hosts_events
    drop_table :event_hosts_series
  end
end
