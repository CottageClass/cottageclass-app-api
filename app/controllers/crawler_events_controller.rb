class CrawlerEventsController < ActionController::Base
  def show
    @event = Event.eager.find_by id: params[:id]

   set_meta_tags og: {
     image: 'https://storage.googleapis.com/cottageclass-prod/images/lets-share-playdates-and-childcare.png',
     url: crawler_event_url,
     description: @event.name,
     titie: @event.name
   }
  end
end
