class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_action :verify_authenticity_token, only: %i[destroy]

  respond_to :json

  def create
    build_resource sign_up_params
    resource.save
    if resource.errors.blank?
      render json: UserSerializer.new(resource).serialized_json, status: :ok
    else
      render json: { errors: resource.errors }, status: :unprocessable_entity
    end
  end

  def sign_up_params
    params.permit :first_name, :last_name, :email, :password, :avatar
  end
end
