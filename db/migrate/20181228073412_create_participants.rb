class CreateParticipants < ActiveRecord::Migration[5.2]
  def change
    create_table :participants do |t|
      t.references :participable, polymorphic: true, null: false, index: false
      t.references :user, null: false, index: false
      t.timestamps null: true
      t.index %i[participable_type participable_id user_id],
              unique: true,
              name: :index_participants_on_participable_type_participable_id_user_id
    end
  end
end
