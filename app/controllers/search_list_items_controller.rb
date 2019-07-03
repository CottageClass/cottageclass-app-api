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

    miles = miles.to_f
    location = []
    location = [latitude, longitude] if [latitude, longitude].all?(&:present?)
    location = [current_user.latitude, current_user.longitude] if location.blank? && current_user.present?

    unless miles.positive? && location.all?(&:present?)
      render status: 400
      return
    end
    showcase = SearchListItem.near(location.map(&:to_f), miles).includes(user: :children).includes(:itemable)
    showcase = showcase.joins('INNER JOIN events ON events.id = itemable_id')
    showcase = showcase.child_age_range(min_age, max_age)
    showcase = showcase.where.not(user_id: current_user.id) if current_user.present?
    showcase = showcase.where itemable_type: :Event

    childcare_requests = SearchListItem.near(location.map(&:to_f), miles).includes(user: :children).includes(:itemable)
    childcare_requests = childcare_requests.child_age_range(min_age, max_age)
    childcare_requests = childcare_requests.where itemable_type: :ChildcareRequest
    childcare_requests = childcare_requests.where.not(user_id: current_user.id) if current_user.present?
    childcare_requests_array = childcare_requests.to_a.uniq { |i| i.user.id }

    # convert to array to perform application level logic
    showcase_array = showcase.to_a.uniq { |i| i.user.id }

    showcase_users = showcase_array.map { |s| s.user.id }
    childcare_request_users = childcare_requests_array.map { |s| s.user.id }

    users = showcase_users | childcare_request_users
    items = childcare_requests_array + showcase_array


    links = {}
    meta = { items_count: items.count(:all) }
    if page.present?
      page_size ||= 10
      items = Kaminari.paginate_array(items).page(page).per(page_size)

      meta[:pages_count] = items.total_pages
      links[:self] = path.call page: items.current_page, page_size: page_size
      links[:previous] = path.call(page: items.prev_page, page_size: page_size) unless items.first_page?
      links[:next] = path.call(page: items.next_page, page_size: page_size) unless items.last_page?
    end

    serializer = SearchListItemSerializer.new items, include: %i[itemable user],
                                                     links: links,
                                                     meta: meta,
                                                     params: { current_user: current_user }
    json_hash = serializer.serializable_hash
    render json: json_hash, status: :ok
  end
end
