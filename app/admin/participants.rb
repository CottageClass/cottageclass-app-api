ActiveAdmin.register Participant do
  config.sort_order = 'id_desc'

  belongs_to :event

  actions :index, :new, :create, :edit, :update, :destroy

  permit_params participant_children_attributes: %i[id child_id _destroy]

  index do
    selectable_column
    column :id
    column 'Event', :participable, sortable: :participable_id
    column :user
    actions
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    f.inputs 'Data' do
      f.li do
        f.label 'Event'
        f.span link_to(f.object.participable.name, edit_admin_event_path(f.object.participable))
      end
      f.li do
        f.label 'User'
        f.span link_to(f.object.user.name, admin_user_path(f.object.participable))
      end
      f.has_many :participant_children, allow_destroy: true do |participant_child_f|
        participant_child_f.input :child, collection: f.object.user.children
      end
    end
    f.actions
  end
end
