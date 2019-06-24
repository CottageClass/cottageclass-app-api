class CrawlerEventsController < ActionController::Base
  def show
    @event = Event.eager.find_by id: params[:id]
    month = @event.month_abbreviated
    date = @event.day_of_month
    time = @event.start_time_hour

    set_meta_tags og: {
      image: 'https://storage.googleapis.com/cottageclass-prod/images/lets-share-playdates-and-childcare.png',
      url: crawler_event_url,
      titie: @event.name,
      description: "#{@event.host_first_name} is hosting a playdate #{month} #{date} @ #{time}. Can you come?"
    }
  end
end
