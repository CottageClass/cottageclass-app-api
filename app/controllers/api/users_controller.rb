class API::UsersController < API::BaseController
  before_action :load_user, only: %i[show]

  def index
    users_index users: User.includes(:children),
                miles: params[:miles],
                latitude: params[:latitude],
                longitude: params[:longitude],
                min_age: params[:min_age],
                max_age: params[:max_age],
                page: params[:page],
                page_size: params[:page_size],
                path: proc { |**parameters| index_api_users_path parameters }
  end

  def show
    serializer = if current_user && current_user.id == @user.id
                   CurrentUserSerializer.new @user, include: %i[children]
                 else
                   PublicUserSerializer.new @user, include: %i[children]
                 end
    render json: serializer.serializable_hash, status: :ok
  end

  private

  def users_index(users:, miles:, latitude:, longitude:, page:, page_size:, path:, min_age:, max_age:)
    if min_age.present? or max_age.present?
      min_age ||=  0
      min_age = min_age.to_i
      max_age ||= 17
      max_age = max_age.to_i
      earliest_birthday = (Time.current - (max_age+ 1 ).year.seconds)
      latest_birthday = (Time.current - min_age.year.seconds)
      time_range = earliest_birthday..latest_birthday

      users = users.joins(:children).where('children.birthday' => time_range)
    end

    miles = miles.to_i
    if miles.positive?
      location = []
      location = [latitude, longitude] if [latitude, longitude].all?(&:present?)
      location = [current_user.latitude, current_user.longitude] if location.blank? && current_user.present?
      users = users.near(location.map(&:to_f), miles) if location.all?(&:present?)
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

    serializer = PublicUserSerializer.new users, include: %i[children user_reviews user_reviews.reviewer],
                                                 links: links,
                                                 meta: meta
    render json: serializer.serializable_hash, status: :ok
  end

  def load_user
    @user = User.find_by id: params[:id]
    render(json: {}, status: :not_found) if @user.blank?
  end
end
