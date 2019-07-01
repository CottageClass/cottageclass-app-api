class SearchListItemsController < ApiController
  def index
    miles = params[:miles]
    latitude = params[:latitude]
    longitude = params[:longitude]
    min_age = params[:min_age]
    max_age = params[:max_age]
    page = params[:page]
    page_size = params[:page_size]
    path = proc { |**parameters| feed_path parameters }

    items = SearchListItem.joins(:user).where(itemable: nil)
    items = items.where.not(user_id: current_user.id) if current_user.present?

    if min_age.present? || max_age.present?
      min_age ||= 0
      min_age = min_age.to_i
      max_age ||= 17
      max_age = max_age.to_i
      earliest_birthday = (Time.current - (max_age + 1).year.seconds)
      latest_birthday = (Time.current - min_age.year.seconds)
      time_range = earliest_birthday..latest_birthday

      items = items.joins('INNER JOIN children ON children.id = users.id').where('children.birthday' => time_range)
    end

    miles = miles.to_f
    if miles.positive?
      location = []
      location = [latitude, longitude] if [latitude, longitude].all?(&:present?)
      location = [current_user.latitude, current_user.longitude] if location.blank? && current_user.present?
      if location.all?(&:present?)
        items = items.near(location.map(&:to_f), miles)
        items = items.joins 'LEFT JOIN events ON users.showcase_event_id = events.id'
        items = items.reorder 'events.recency_score ASC NULLS LAST, distance ASC'
      end
    end

    links = {}
    meta = { items_count: items.count(:all) }
    if page.present?
      page_size ||= 10
      items = items.page(page).per page_size

      meta[:pages_count] = items.total_pages
      links[:self] = path.call page: items.current_page, page_size: page_size
      links[:previous] = path.call(page: items.prev_page, page_size: page_size) unless items.first_page?
      links[:next] = path.call(page: items.next_page, page_size: page_size) unless items.last_page?
    end

    serializer = PublicUserSerializer.new items.map(&:user), include: %i[children showcase_event],
                                                             links: links,
                                                             meta: meta,
                                                             params: { current_user: current_user }
    render json: serializer.serializable_hash, status: :ok
  end
end
