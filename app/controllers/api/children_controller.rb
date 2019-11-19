class API::ChildrenController < API::BaseController
  before_action :authenticate_user!, :load_child

  def update
    if @child.update(safe_params)
      serializer = ChildUnrestrictedSerializer.new @child
      render json: serializer.serializable_hash, status: :ok
    else
      render json: { errors: @child.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def load_child
    @child = current_user.children.find_by id: params[:id]
    render(json: {}, status: :not_found) if @child.blank?
  end

  def safe_params
    params.require(:child)
  end
end
