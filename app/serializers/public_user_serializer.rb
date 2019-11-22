class PublicUserSerializer < BaseSerializer
  include_children = proc { |_record, params|
    !params[:skip_children]
  }

  set_type :user
  has_many :children, serializer: ChildSerializer, if: include_children
  belongs_to :place

  attributes(*User::PUBLIC_ATTRIBUTES)
  attribute :last_initial do |user|
    user.last_name[0, 1].upcase if user.last_name.present?
  end
  attribute :first_name do |user|
    user.first_name.slice(0, 1).capitalize + user.first_name.slice(1..-1) if user.first_name.present?
  end
  attribute :starred do |user, params|
    user.starred? params[:current_user]
  end
  attribute :dark_starred do |user, params|
    user.dark_starred? params[:current_user]
  end
end
