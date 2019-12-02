class API::UserGroupsController < API::BaseController
  before_action :authenticate_user!, :load_user_group, :reject_nonmember

  def show
    serializer = UserGroupSerializer.new @user_group,
                                         include: %i[members],
                                         params: { skip_children: true }
    render json: serializer.serializable_hash, status: :ok
  end

  private

  def load_user_group
    @user_group = UserGroup.find_by id: params[:id] if params[:id].present?
    render(json: {}, status: :not_found) if @user_group.blank?
  end

  def reject_nonmember
    if !current_user || !@user_group.members.include?(current_user)
      render json: { errors: ['You do not have permission to perform this operation'] }, status: 401
    end
  end
end
