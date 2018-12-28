class CreateParticipantChildren < ActiveRecord::Migration[5.2]
  def change
    create_table :participant_children do |t|
      t.references :participant, null: false
      t.references :participable, polymorphic: true, null: false, index: false
      t.references :child, null: false, index: false
      t.timestamps null: true
      t.index %i[participable_type participable_id child_id],
              unique: true,
              name: :idx_participants_on_participable_type_participable_id_child_id
    end
  end
end
