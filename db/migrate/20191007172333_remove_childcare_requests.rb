class RemoveChildcareRequests < ActiveRecord::Migration[5.2]
  def change
    drop_table :childcare_requests
  end
end
