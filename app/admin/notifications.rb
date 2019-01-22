ActiveAdmin.register Notification do
  config.sort_order = 'id_desc'
  menu parent: 'Data'

  belongs_to :user, optional: true

  actions :index, :destroy

  filter :created_at

  index do
    selectable_column
    column :id
    column :recipient
    column :notifiable
    column :created_at
    column :body
    actions
  end
end
