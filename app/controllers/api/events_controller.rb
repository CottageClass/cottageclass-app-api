class API::EventsController < API::BaseController
  def index
    skope = params[:skope] || 'all'
    events = Event.send skope
    links = {}
    meta = { events_count: events.count }
    if params[:page].present?
      page_size = params[:page_size] || 10
      events = events.page(params[:page]).per page_size

      skope_name = %w[past upcoming].include?(skope) ? skope : nil
      meta[:pages_count] = events.total_pages
      links[:self] = index_api_events_path(skope: skope_name, page: events.current_page, page_size: page_size)
      unless events.first_page?
        links[:previous] = index_api_events_path(skope: skope_name, page: events.prev_page, page_size: page_size)
      end
      unless events.last_page?
        links[:next] = index_api_events_path(skope: skope_name, page: events.next_page, page_size: page_size)
      end
    end

    serializer = EventSerializer.new events, include: %i[event_hosts],
                                             params: { current_user: current_user },
                                             links: links,
                                             meta: meta
    render json: serializer.serializable_hash, status: :ok
  end

  def show
    event = Event.find params[:id]

    serializer = EventSerializer.new event, include: %i[event_hosts], params: { current_user: current_user }
    render json: serializer.serializable_hash, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: {}, status: :not_found
  end
end
