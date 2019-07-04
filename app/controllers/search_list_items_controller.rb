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
    events = SearchListItem.near(location.map(&:to_f), miles)
    events = events.includes(:itemable, user: { children: :emergency_contacts })

    events = events.where itemable_type: :Event
    events = events.child_age_range(min_age, max_age)
    events = events.where.not(user_id: current_user.id) if current_user.present?
    events = events.merge(Event.upcoming)
    events = events.joins('INNER JOIN events ON events.id = itemable_id')

    childcare_requests = SearchListItem.near(location.map(&:to_f), miles)
    childcare_requests = childcare_requests.includes(user: :children)
    childcare_requests = childcare_requests.child_age_range(min_age, max_age)
    childcare_requests = childcare_requests.where itemable_type: :ChildcareRequest
    childcare_requests = childcare_requests.where.not(user_id: current_user.id) if current_user.present?

    # convert to array to perform application level logic
    event_array = events.to_a
    childcare_request_array = childcare_requests.to_a

    preloader = ActiveRecord::Associations::Preloader.new
    if current_user.present?
      preloader.preload(event_array,
                        { itemable: %i[received_stars] },
                        Star.where(giver_id: current_user.id,
                                   starable_type: Event.name))
    end

    preloader.preload event_array, itemable: %i[participants
                                                participating_users
                                                user
                                                event_hosts]

    # byebug
    # find all users that have no eligible events or childcare_requests
    event_users = event_array.map { |s| s.user.id }
    childcare_request_users = childcare_request_array.map { |s| s.user.id }
    seen_users = event_users | childcare_request_users
    unseen_users = SearchListItem.where(itemable_id: nil).where.not(user_id: seen_users)
    unseen_users = unseen_users.to_a

    # reduce to one per user.  the last created
    childcare_request_array = childcare_request_array.sort_by(&:created_at)
    childcare_request_array.reverse!
    childcare_request_array = childcare_request_array.uniq { |i| i.user.id }

    event_array = event_array.sort_by(&:created_at)
    event_array.reverse!
    event_array = event_array.uniq { |i| i.user.id }

    items = childcare_request_array + event_array
    items.sort! do |i|
      current_user.match_score i.user
    end

    # these go last.  we don't have to find them if we aren't at this page yet.
    items += unseen_users

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

    serializer = SearchListItemSerializer.new items, include: %i[itemable user.children.emergency_contacts],
                                                     links: links,
                                                     meta: meta,
                                                     params: { current_user: current_user }
    json_hash = serializer.serializable_hash
    render json: json_hash, status: :ok
  end
end
