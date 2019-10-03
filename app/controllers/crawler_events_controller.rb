class CrawlerEventsController < ActionController::Base
  skip_before_action :track_ahoy_visit
  def show
    @event = Event.eager.find_by id: params[:id]
    month = @event.month_abbreviated
    date = @event.day_of_month
    time = @event.start_time_hour

    set_meta_tags og: {
      image: 'https://storage.googleapis.com/cottageclass-prod/images/lilypad-youre-invited-to-a-playdate.png',
      url: crawler_event_url,
      description: @event.name,
      title: "#{@event.user.first_name} is hosting a playdate #{month} #{date} @ #{time}. Can you come?"
    }
  end
end
