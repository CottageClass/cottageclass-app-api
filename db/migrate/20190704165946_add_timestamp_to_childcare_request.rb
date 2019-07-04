class AddTimestampToChildcareRequest < ActiveRecord::Migration[5.2]
  def change
    add_column :childcare_requests, :created_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }
  end
end
