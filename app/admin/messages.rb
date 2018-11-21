ActiveAdmin.register Message do
  # to edit forms and menus, see: https://activeadmin.info/5-forms.html

  menu priority: 2
  permit_params :content
end
