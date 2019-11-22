class API::CommentsController < API::BaseController
  before_action :authenticate_user!, :load_user_group, :reject_nonmember

  def index
    serializer = CommentSerializer.new @user_group.comments, include: %i[sender]
    render json: serializer.serializable_hash, status: :ok
  end

  def create
    comment = @user_group.comments.build safe_params
    comment.sender = current_user
    if comment.save!
      serializer = CommentSerializer.new comment, include: %i[sender]
      render json: serializer.serializable_hash, status: :created
    end
  end

  private

  def load_user_group
    @user_group = UserGroup.find_by id: params[:user_group_id] if params[:user_group_id].present?
    render(json: {}, status: :not_found) if @user_group.blank?
  end

  def safe_params
    params.require(:comment).permit(:content)
  end

  def reject_nonmember
    if !current_user || !@user_group.members.include?(current_user)
      render json: { errors: ['You do not have permission to perform this operation'] }, status: 404
    end
  end
end
