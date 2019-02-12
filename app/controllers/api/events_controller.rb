class API::EventsController < API::BaseController
  before_action :authenticate_user, only: %i[created participated update destroy]
  before_action :load_event, only: %i[show update destroy]
  before_action :requires_event_owner, only: %i[update destroy]

  def index
    events_index events: Event.includes(:user, :event_hosts),
                 skope: params[:skope],
                 miles: params[:miles],
                 latitude: params[:latitude],
                 longitude: params[:longitude],
                 sort: params[:sort],
                 page: params[:page],
                 page_size: params[:page_size],
                 path: proc { |**parameters| index_api_events_path parameters }
  end

  def created
    events_index events: current_user.events,
                 skope: params[:skope],
                 miles: params[:miles],
                 latitude: params[:latitude],
                 longitude: params[:longitude],
                 sort: params[:sort],
                 page: params[:page],
                 page_size: params[:page_size],
                 path: proc { |**parameters| created_events_api_user_path parameters }
  end

  def participated
    events_index events: current_user.participated_events,
                 skope: params[:skope],
                 miles: params[:miles],
                 latitude: params[:latitude],
                 longitude: params[:longitude],
                 sort: params[:sort],
                 page: params[:page],
                 page_size: params[:page_size],
                 path: proc { |**parameters| participated_events_api_user_path parameters }
  end

  def show
    @event = Event.eager.find_by id: params[:id]
    serializer = EventSerializer.new @event, include: %i[
      event_hosts
      participants
      participants.participant_children
      user
      user.user_reviews
      user.user_reviews.reviewer
    ],
                                             params: { current_user: current_user }
    render json: serializer.serializable_hash, status: :ok
  end

  def update
    if @event.update(safe_params)
      serializer = EventSerializer.new @event, include: %i[event_hosts], params: { current_user: current_user }
      render json: serializer.serializable_hash, status: :ok
    else
      render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @event.destroy
      render json: {}, status: :ok
    else
      render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def events_index(events:, skope:, miles:, latitude:, longitude:, sort: nil, page:, page_size:, path:)
    skope ||= 'all'
    events = events.send skope

    miles = miles.to_i
    if miles.positive?
      location = []
      location = [latitude, longitude] if [latitude, longitude].all?(&:present?)
      location = [current_user.latitude, current_user.longitude] if location.blank? && current_user.present?
      events = events.near(location.map(&:to_f), miles) if location.all?(&:present?)
    end

    if %w[chronological].include?(sort)
      events = events.reorder starts_at: :asc
    elsif miles.positive?
      events = events.reorder 'distance ASC'
    end

    links = {}
    meta = { events_count: events.count(:all) }
    if page.present?
      page_size ||= 10
      events = events.page(page).per page_size

      skope_name = %w[past upcoming].include?(skope) ? skope : nil
      meta[:pages_count] = events.total_pages
      links[:self] = path.call(skope: skope_name, page: events.current_page, page_size: page_size)
      unless events.first_page?
        links[:previous] = path.call skope: skope_name, page: events.prev_page, page_size: page_size
      end
      links[:next] = path.call(skope: skope_name, page: events.next_page, page_size: page_size) unless events.last_page?
    end

    serializer = EventSerializer.new events, include: %i[event_hosts user user.user_reviews user.user_reviews.reviewer],
                                             params: { current_user: current_user },
                                             links: links,
                                             meta: meta
    render json: serializer.serializable_hash, status: :ok
  end

  def load_event
    @event = Event.find_by id: params[:id]
    render(json: {}, status: :not_found) if @event.blank?
  end

  def requires_event_owner
    render(json: {}, status: :forbidden) unless @event.user == current_user
  end

  def safe_params
    params.require(:event).permit :name, :starts_at, :ends_at, :has_pet, :house_rules, :pet_description,
                                  :maximum_children, :child_age_minimum, :child_age_maximum,
                                  activity_names: [],
                                  foods: [],
                                  event_hosts_attributes: %i[id name email phone _destroy]
  end
end
