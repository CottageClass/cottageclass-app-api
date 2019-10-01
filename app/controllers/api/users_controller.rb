class API::UsersController < API::BaseController
  before_action :load_user, only: %i[show destroy]
  before_action :authenticate_user!, only: %i[destroy]
  before_action :reject_nonmatching_user, only: %i[update]

  def feed
    users = User
    users = users.where.not(id: current_user.id) if current_user.present?
    users_index users: users,
                miles: params[:miles],
                latitude: params[:latitude],
                longitude: params[:longitude],
                min_age: params[:min_age],
                max_age: params[:max_age],
                page: params[:page],
                page_size: params[:page_size],
                path: proc { |**parameters| index_api_users_path parameters }
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

  def show
    serializer = if current_user && current_user.id == @user.id
                   CurrentUserSerializer.new @user, include: %i[children]
                 else
                   PublicUserSerializer.new @user,
                                            include: %i[children],
                                            params: { current_user: current_user }
                 end
    render json: serializer.serializable_hash, status: :ok
  end

  def destroy
    if current_user && current_user.id == @user.id
      render status: 200 if @user.destroy
    else
      render status: 401
    end
  end

  private

  def reject_nonmatching_user
    if !current_user || current_user.id.to_i != params[:id].to_i
      render json: { errors: ['No matching user found'] }, status: 404
    end
  end

  def users_index(users:, miles:, latitude:, longitude:, page:, page_size:, path:, min_age:, max_age:)
    if min_age.present? || max_age.present?
      min_age ||= 0
      min_age = min_age.to_i
      max_age ||= 17
      max_age = max_age.to_i
      earliest_birthday = (Time.current - (max_age + 1).year.seconds)
      latest_birthday = (Time.current - min_age.year.seconds)
      time_range = earliest_birthday..latest_birthday

      users = users.joins(:children).where('children.birthday' => time_range)
    end

    miles = miles.to_f
    if miles.positive?
      location = []
      location = [latitude, longitude] if [latitude, longitude].all?(&:present?)
      location = [current_user.latitude, current_user.longitude] if location.blank? && current_user.present?
      if location.all?(&:present?)
        users = users.near(location.map(&:to_f), miles)
        users = users.joins 'LEFT JOIN events ON users.showcase_event_id = events.id'
        users = users.reorder 'events.recency_score ASC NULLS LAST, distance ASC'
      end
    end

    links = {}
    meta = { users_count: users.count(:all) }
    if page.present?
      page_size ||= 10
      users = users.page(page).per page_size

      meta[:pages_count] = users.total_pages
      links[:self] = path.call page: users.current_page, page_size: page_size
      links[:previous] = path.call(page: users.prev_page, page_size: page_size) unless users.first_page?
      links[:next] = path.call(page: users.next_page, page_size: page_size) unless users.last_page?
    end

    serializer = PublicUserSerializer.new users, include: %i[children showcase_event],
                                                 links: links,
                                                 meta: meta,
                                                 params: { current_user: current_user }
    render json: serializer.serializable_hash, status: :ok
  end

  def load_user
    @user = User.find_by id: params[:id]
    render(json: {}, status: :not_found) if @user.blank?
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
                                 :setting_email_notifications,
                                 :setting_max_distance,
                                 :place_id,
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
