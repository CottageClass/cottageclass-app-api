class API::EventsController < API::BaseController
  before_action :authenticate_user, only: %i[update]
  before_action :load_event, only: %i[show update]

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
    serializer = EventSerializer.new @event, include: %i[event_hosts], params: { current_user: current_user }
    render json: serializer.serializable_hash, status: :ok
  end

  def update
    json = {}
    status = if @event.user == current_user
               if @event.update(safe_params)
                 serializer = EventSerializer.new @event, include: %i[event_hosts],
                                                          params: { current_user: current_user }
                 json = serializer.serializable_hash
                 :ok
               else
                 json = { errors: @event.errors.full_messages }
                 :unprocessable_entity
               end
             else
               :forbidden
             end
    render json: json, status: status
  end

  private

  def load_event
    @event = Event.find_by id: params[:id]
    render(json: {}, status: :not_found) if @event.blank?
  end

  def safe_params
    params.require(:event).permit :name, :starts_at, :ends_at, :has_pet, :house_rules, :pet_description,
                                  :maximum_children, :child_age_minimum, :child_age_maximum,
                                  activity_names: [],
                                  foods: [],
                                  event_hosts_attributes: %i[id name email phone _destroy]
  end
end
