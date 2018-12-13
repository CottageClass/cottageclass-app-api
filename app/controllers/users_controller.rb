class UsersController < ApiController
  before_action :authenticate_user, except: %i[create]
  before_action :reject_nonmatching_user, only: [:show, :update, :inquiries]
  before_action :reject_user_not_in_network, only: [:index]
  before_action :require_admin!, only: [:admin_index]

  def index
    # false defends against returning users who have network `""
    # - TODO: write some tests for this
    desired_network_code = params[:network_code] || false
    @users = User.where(network_code: desired_network_code)
    render json: UserInNetworkSerializer.json_for(@users, include: [:children]), status: 200
  end

  def create
    @user = User.new signup_params
    @user.direct = true
    if @user.save
      render json: UserSerializer.json_for(@user), status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    @user = current_user
    render json: UserSerializer.json_for(@user, include: [:children]), status: 200
  end

  def update
    @user = current_user
    if @user.update_attributes(user_params)
      render json: UserSerializer.json_for(@user, include: [:children]), status: 200
    else
      render json: { errors: @user.errors.full_messages }, status: 400
    end
  end

  def inquiries
    @users = current_user
      .inquirers
      .in_network(current_user.network_code)

    render json: UserInNetworkSerializer.json_for(@users, include: [:children]), status: 200
  end

  def admin_index
    @users = User.all
    render json: MinimallyIdentifiableUserSerializer.json_for(@users), status: 200
  end

  private

  def reject_nonmatching_user
    if !current_user || current_user.id.to_i != params[:id].to_i
      render json: { errors: ["No matching user found"] }, status: 404
    end
  end

  def reject_user_not_in_network
    desired_network_code = params[:network_code]

    if (
      !current_user ||
      !desired_network_code ||
      desired_network_code.length < 1 ||
      current_user.network_code != desired_network_code
    )
      render json: { errors: ["No users found in network"]}, status: 404
    end
  end

  def signup_params
    params.permit :first_name, :last_name, :email, :password
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
      :profile_blurb,
      :onboarding_care_type,
      activities: [],
      children_attributes: [
        :id,
        :parent_id,
        :first_name,
        :birthday,
      ],
    )
  end
end
