ActiveAdmin.register Participant do
  config.sort_order = 'id_desc'

  belongs_to :event

  actions :index, :new, :create, :edit, :update, :destroy

  filter :created_at

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
      f.li do
        f.label :created_at
        f.span f.object.created_at
      end
      f.li do
        f.label :updated_at
        f.span f.object.updated_at
      end
    end
    f.actions
  end
end
