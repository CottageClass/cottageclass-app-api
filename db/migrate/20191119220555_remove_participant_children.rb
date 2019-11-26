class RemoveParticipantChildren < ActiveRecord::Migration[5.2]
  def change
    drop_table :participant_children
  end
end
