ActiveAdmin.register ChildcareRequest do
  config.sort_order = 'id_desc'
  menu parent: 'Data'

  includes :user

  belongs_to :event_series, optional: true

  permit_params %i[user_id content]

  index do
    selectable_column
    column :id
    column :content
    column :user
    column :created_at
  end
end
