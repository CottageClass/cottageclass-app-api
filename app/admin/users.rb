ActiveAdmin.register User do
  config.sort_order = 'id_desc'
  menu priority: 1

  includes :children

  permit_params :email, :facebook_uid, :verified, :first_name, :last_name, :name, :network_code, :profile_blurb,
                :apartment_number

  filter :name
  filter :first_name
  filter :last_name
  filter :verified
  filter :network_code
  filter :facebook_uid
  filter :created_at

  index do
    selectable_column
    column :id
    column :name
    bool_column :verified
    column :network_code
    column :facebook_uid
    column :created_at
    actions
  end
end
