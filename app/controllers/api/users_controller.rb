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
    if user.update!(user_params)
      render json: CurrentUserSerializer.json_for(user, include: %i[
                                                    children
                                                    place
                                                  ],
                                                        params: { current_users_place: true }),
             status: 200
    else
      render json: { errors: user.errors.full_messages }, status: 400
    end
  end

  def show
    serializer = if current_user && current_user.id == @user.id
                   CurrentUserSerializer.new @user,
                                             include: %i[children place],
                                             params: { current_users_place: true }
                 else
                   PublicUserSerializer.new @user,
                                            include: %i[children place],
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
      parent_ids = Child.where(birthday: time_range).pluck(:parent_id).uniq

      users = users.where id: parent_ids
    end

    miles = miles.to_f
    if miles.positive?
      location = []
      location = [latitude, longitude] if [latitude, longitude].all?(&:present?)
      location = [current_user.place.latitude, current_user.place.longitude] if location.blank? && current_user.present?
      users = users.near(location.map(&:to_f), miles)
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

    serializer = PublicUserSerializer.new users, include: %i[children place],
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
    params.require(:user).permit :first_name,
                                 :last_name,
                                 :avatar,
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
                                 :setting_email_notifications,
                                 :setting_max_distance,
                                 :setting_notify_messages_email,
                                 :setting_notify_messages_sms,
                                 :setting_notify_messages_push,
                                 :setting_notify_group_messages_email,
                                 :setting_notify_group_messages_sms,
                                 :setting_notify_group_messages_push,
                                 :setting_notify_event_reminder_email,
                                 :setting_notify_event_reminder_sms,
                                 :setting_notify_event_reminder_push,
                                 :place_id,
                                 source_tags: [],
                                 activities: [],
                                 images: [],
                                 languages: [],
                                 place_attributes: %i[
                                   public
                                   creator_id
                                   google_id
                                   apartment_number
                                 ],
                                 children_attributes: %i[
                                   id
                                   first_name
                                   birthday
                                   school_name
                                   _destroy
                                 ]
  end
end
