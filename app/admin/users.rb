ActiveAdmin.register User do
  # to edit forms and menus, see: https://activeadmin.info/5-forms.html

  menu priority: 1
  permit_params :email,
    :facebook_uid,
    :first_name,
    :last_name,
    :name,
    :network_code,
    :profile_blurb

  includes :children
end
