class API::ChildcareRequestsController < API::BaseController
  before_action :authenticate_user!, only: %i[create destroy update]

  def create
    childcare_request = current_user.childcare_requests.build safe_params
    if childcare_request.save
      render json: ChildcareRequestSerializer.new(childcare_request).serializable_hash,
             status: :created
    else
      render json: { errors: childcare_request.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def update; end

  def show
    childcare_request = ChildcareRequest.find params[:id]
    render json: ChildcareRequestSerializer.new(childcare_request, include: %i[user]).serializable_hash,
           status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: {}, status: :not_found
  end

  def destroy
    childcare_request = ChildcareRequest.find params[:id]
    json = {}
    status = if childcare_request.present?
               if childcare_request.destroy
                 :ok
               else
                 json = { errors: childcare_request.errors.full_messages }
                 :unprocessable_entity
               end
             else
               :not_found
             end
    render json: json, status: status
  end

  def safe_params
    params.require(:childcare_request).permit :content
  end
end
