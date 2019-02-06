class API::UsersController < API::BaseController
  before_action :authenticate_user

  def index
    users_index users: User.includes(:children, user_reviews: :reviewer),
                miles: params[:miles],
                latitude: params[:latitude],
                longitude: params[:longitude],
                page: params[:page],
                page_size: params[:page_size],
                path: proc { |**parameters| index_api_users_path parameters }
  end

  private

  def users_index(users:, miles:, latitude:, longitude:, page:, page_size:, path:)
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

    serializer = UserInNetworkSerializer.new users, include: %i[children user_reviews user_reviews.reviewer],
                                                    links: links,
                                                    meta: meta
    render json: serializer.serializable_hash, status: :ok
  end
end
