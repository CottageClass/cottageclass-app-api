class Crawler::EventsController < ActionController::Base
  skip_before_action :track_ahoy_visit
  def show
    @event = Event.find params[:id]
    month = @event.month_abbreviated
    date = @event.day_of_month
    time = @event.start_time

    image = if @event.images.present?
              @event.images.first
            elsif @event.place.images.present?
              @event.place.images.first
            else
              'https://storage.googleapis.com/cottageclass-prod/images/lilypad-youre-invited-to-a-playdate.png'
            end

    set_meta_tags og: {
      image: image,
      url: crawler_event_url,
      description: @event.name,
      title: "#{@event.user.first_name} is hosting a playdate #{month} #{date} @ #{time}. Can you come?"
    }
  end
end
