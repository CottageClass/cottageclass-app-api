class PublicUserSerializer < BaseSerializer
  set_type :user
  has_many :children, serializer: ChildSerializer
  has_many :user_reviews

  attributes(*User::PUBLIC_ATTRIBUTES)
  attribute :last_initial do |user|
    user.last_name[0, 1]
  end
  attribute :starred do |user, params|
    current_user = params[:current_user]
    if params[:starred_list]
      true
    elsif current_user.nil?
      false
    else
      star = Star.find_by giver: current_user, starable_type: :User, starable_id: user.id
      !star.nil?
    end
  end
end
