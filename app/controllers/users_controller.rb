class UsersController < ApplicationController
  before_action :authenticate_user
  before_action :reject_nonmatching_user, only: [:show, :update]

  def show
    @user = current_user
    render json: Serializers::UserSerializer.json_for(@user, include: [:children]), status: 200
  end

  def update
    @user = current_user
    if @user = @user.update_attributes(user_params)
      render json: Serializers::UserSerializer.json_for(@user, include: [:children]), status: 200
    else
      render json: { errors: @user.errors.full_messages }, status: 400
    end
  end

  private

  def reject_nonmatching_user
    if !current_user || current_user.id.to_i != params[:id].to_i
      render json: { errors: ["No matching user found"] }, status: 404
    end
  end

  def user_params
    params.require(:user).permit(
      :agree_tos,
      :first_name,
      :last_name,
      :street_number,
      :route,
      :locality,
      :admin_area_level_1,
      :admin_area_level_2,
      :country,
      :postal_code,
      :latitude,
      :longitude,
      :phone_country_code,
      :phone_area_code,
      :phone_number,
      :available_mornings,
      :available_afternoons,
      :available_evenings,
      :available_weekends,
      :network_code,
      activities: [],
      children_attributes: [
        :id,
        :user_id,
        :first_name,
        :birthday,
      ],
    )
  end
end
