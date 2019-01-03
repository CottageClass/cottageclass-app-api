ActiveAdmin.register EventSeries do
  config.sort_order = 'id_desc'
  menu parent: 'Data'

  actions :index, :new, :create, :edit, :update, :destroy

  permit_params :name, :start_date, :starts_at, :ends_at, :repeat_for, :interval, :maximum_children, :child_age_minimum,
                :child_age_maximum, :has_pet, :house_rules, :pet_description, :activity_names, :foods,
                event_hosts_attributes: %i[id verified _destroy]

  filter :name
  filter :start_date

  before_save do |instance|
    instance.activity_names = params[:event_series][:activity_names].split(',')
    instance.foods = params[:event_series][:foods].split(',')
  end

  index do
    selectable_column
    column :id
    column :name
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
      f.li do
        f.label :time_zone
        f.span f.object.time_zone
      end
      f.input :start_date
      f.input :starts_at
      f.input :ends_at
      f.input :has_pet
      f.input :pet_description
      f.input :activity_names, as: :tags
      f.input :foods, as: :tags
      f.input :house_rules
      f.input :repeat_for
      f.input :interval
      f.input :maximum_children
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
      f.has_many :event_hosts, allow_destroy: true do |event_host_f|
        event_host_f.input :name
        event_host_f.input :verified
      end
    end
    f.actions
  end
end
