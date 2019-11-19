ActiveAdmin.register EventSeries do
  config.sort_order = 'id_desc'
  menu parent: 'Data'

  actions :index, :new, :create, :edit, :update, :destroy

  permit_params :name, :description, :start_date, :starts_at, :ends_at, :repeat_for, :interval,
                :child_age_minimum, :child_age_maximum

  filter :name
  filter :start_date

  includes :user

  index do
    selectable_column
    column :id
    column :name
    column :description
    column :user
    column :start_date
    column(:starts_at) { |instance| instance.starts_at.strftime('%T') }
    column(:ends_at) { |instance| instance.ends_at.strftime('%T') }
    column :created_at
    actions do |instance|
      item 'Events', admin_event_series_events_path(instance), class: 'member_link'
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    f.inputs 'Data' do
      f.input :name
      f.input :start_date
      f.input :starts_at
      f.input :ends_at
      f.input :repeat_for
      f.input :interval
      f.input :child_age_minimum
      f.input :child_age_maximum
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
