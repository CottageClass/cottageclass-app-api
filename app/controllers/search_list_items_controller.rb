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
    items = items.child_age_range(min_age, max_age)

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

    # convert to array to perform application level logic
    items = items.to_a.uniq { |i| i.user.id }

    # remove user_matches from array and add them to the beginning
    user_matches = current_user.matched_users if current_user.present?
    user_matches ||= []

    user_matches.reverse_each do |user_match|
      # find the first list item from this user
      item_index = items.find_index do |i|
        i.user.id == user_match.id
      end
      next if item_index.nil?

      item = items[item_index]
      items.delete_at(item_index)
      items.unshift(item)
    end

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

    serializer = PublicUserSerializer.new items.map(&:user), include: %i[children showcase_event],
                                                             links: links,
                                                             meta: meta,
                                                             params: { current_user: current_user }
    render json: serializer.serializable_hash, status: :ok
  end
end
