class API::EventsController < API::BaseController
  before_action :authenticate_user!, only: %i[participated update destroy starred]
  before_action :load_user, only: %i[created participated]
  before_action :load_event, only: %i[show update destroy]
  before_action :requires_event_owner, only: %i[update destroy]

  def starred
    events = Event.upcoming.joins(:event_series)
      .joins('JOIN stars ON stars.starable_id = event_series.id')
      .where('starable_type =?', 'EventSeries')
      .where('stars.giver_id = ?', current_user.id)
      .includes(%i[participants user place event_series])

    serializer = EventSerializer.new events, include: %i[participants
                                                         user
                                                         place
                                                         event_series],
                                             params: { current_user: current_user }
    render json: serializer.serializable_hash, status: :ok
  end

  def index
    events = Event.includes(:user, :place, user: :children)
    events_index events: events.joins(:event_series),
                 skope: params[:skope],
                 miles: params[:miles],
                 latitude: params[:latitude],
                 longitude: params[:longitude],
                 min_age: params[:min_age],
                 max_age: params[:max_age],
                 date: params[:date],
                 weekday: params[:weekday],
                 sort: params[:sort],
                 page: params[:page],
                 page_size: params[:page_size],
                 path: proc { |**parameters| index_api_events_path parameters }
  end

  def created
    events_index events: @user.events.joins(:event_series),
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
    events_index events: @user.participated_events.joins(:event_series),
                 skope: params[:skope],
                 miles: params[:miles],
                 latitude: params[:latitude],
                 longitude: params[:longitude],
                 sort: params[:sort],
                 page: params[:page],
                 page_size: params[:page_size],
                 path: proc { |**parameters| participated_events_api_user_path parameters }
  end

  def place
    events = Event.joins(:event_series).where('event_series.place_id = ?', params[:place_id])
    events_index events: events.joins(:event_series).includes(:place),
                 skope: params[:skope],
                 page: params[:page],
                 page_size: params[:page_size],
                 path: proc { |**parameters| place_events_api_place_events_path parameters }
  end

  def show
    @event = Event.eager.find_by id: params[:id]
    serializer = EventSerializer.new @event, include: %i[ participants
                                                          user
                                                          place
                                                          user.children
                                                          event_series],
                                             params: { current_user: current_user }
    render json: serializer.serializable_hash, status: :ok
  end

  def update
    if @event.update(safe_params)
      serializer = EventSerializer.new @event, params: { current_user: current_user }
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

  def events_index(events:, skope:, miles: nil, latitude: nil, longitude: nil,
                   min_age: nil, max_age: nil, sort: nil, page:, page_size:, path:,
                   date: nil, weekday: nil)
    skope ||= 'all'
    events = events.send(skope).includes user: %i[children]

    if min_age.present? || max_age.present?
      min_age ||= 0
      min_age = min_age.to_i
      max_age ||= 17
      max_age = max_age.to_i

      events = events.where('events.child_age_minimum <= ? AND events.child_age_maximum >= ?', max_age, min_age)
    end

    miles = miles.to_f
    if miles.positive?
      location = []
      location = [latitude, longitude] if [latitude, longitude].all?(&:present?)
      location = [current_user.place.latitude, current_user.place.longitude] if location.blank? && current_user.present?
      events = events.near(location.map(&:to_f), miles) if location.all?(&:present?)
    end

    if date.present?
      events = events.where(starts_at: date.to_date.all_day)
    elsif weekday.present?
      events = events.where('extract(dow from events.starts_at) = ?', weekday)
    end

    events = events.reorder starts_at: :asc

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

    serializer = EventSerializer.new events, include: %i[participants
                                                         user
                                                         place
                                                         event_series],
                                             params: { current_user: current_user },
                                             links: links,
                                             meta: meta
    render json: serializer.serializable_hash, status: :ok
  end

  def load_user
    @user = if params[:user_id].present?
              User.find_by id: params[:user_id]
            elsif current_user.present?
              current_user
            end
    render(json: {}, status: :not_found) if @user.blank?
  end

  def load_event
    @event = Event.find_by id: params[:id]
    render(json: {}, status: :not_found) if @event.blank?
  end

  def requires_event_owner
    render(json: {}, status: :forbidden) unless @event.user == current_user
  end

  def safe_params
    params.require(:event).permit :name,
                                  :description,
                                  :starts_at,
                                  :ends_at,
                                  :child_age_minimum,
                                  :child_age_maximum,
                                  images: []
  end
end
