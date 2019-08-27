class UsersController < ApiController
  before_action :authenticate_user!
  before_action :reject_nonmatching_user, only: %i[show update]
  before_action :require_admin!, only: [:admin_index]

  def index
    users = User.all
    render json: PublicUserSerializer.json_for(users,
                                               include: %i[children],
                                               params: { current_user: current_user }),
           status: 200
  end

  def update
    user = current_user
    if user.update(user_params)
      render json: CurrentUserSerializer.json_for(user, include: %i[
                                                    children
                                                    children.emergency_contacts
                                                  ]),
             status: 200
    else
      render json: { errors: user.errors.full_messages }, status: 400
    end
  end

  def admin_index
    @users = User.all
    render json: MinimallyIdentifiableUserSerializer.json_for(@users), status: 200
  end

  private

  def reject_nonmatching_user
    if !current_user || current_user.id.to_i != params[:id].to_i
      render json: { errors: ['No matching user found'] }, status: 404
    end
  end

  def user_params
    params.require(:user).permit :agree_tos,
                                 :first_name,
                                 :last_name,
                                 :avatar,
                                 :street_number,
                                 :route,
                                 :locality,
                                 :sublocality,
                                 :apartment_number,
                                 :neighborhood,
                                 :admin_area_level_1,
                                 :admin_area_level_2,
                                 :country,
                                 :postal_code,
                                 :latitude,
                                 :longitude,
                                 :pet_description,
                                 :has_pet,
                                 :house_rules,
                                 :phone_country_code,
                                 :phone_area_code,
                                 :phone_number,
                                 :available_mornings,
                                 :available_afternoons,
                                 :available_evenings,
                                 :available_weekends,
                                 :profile_blurb,
                                 :onboarding_care_type,
                                 :job_position,
                                 :employer,
                                 :highest_education,
                                 :school,
                                 :instagram_user,
                                 :twitter_user,
                                 :linkedin_user,
                                 :referrer,
                                 settings: { email: [:receive_weekly_email],
                                             matching: [:max_distance] },
                                 source_tags: [],
                                 activities: [],
                                 images: [],
                                 languages: [],
                                 children_attributes: [
                                   :id,
                                   :first_name,
                                   :birthday,
                                   :school_name,
                                   { allergies: [] },
                                   { dietary_restrictions: [] },
                                   :special_needs,
                                   :_destroy
                                 ]
  end
end
