ActiveAdmin.register Message do
  # to edit forms and menus, see: https://activeadmin.info/5-forms.html

  menu priority: 2
  permit_params :content
  index do
    column :id
    column :sender
    column :receiver
    column :content
    column :created_at
    column :updated_at
  end
end
