class Crawler::PlacesController < ActionController::Base
  skip_before_action :track_ahoy_visit
  def show
    @place = Place.find params[:id]
    render status: 404 unless @place.public

    image = if @place.images.present?
              @place.images.first
            else
              'https://storage.googleapis.com/cottageclass-prod/images/lilypad-youre-invited-to-a-playdate.png'
            end

    set_meta_tags og: {
      image: image,
      url: crawler_place_url,
      description: @place.name,
      title: "Check out playdates at #{@place.name} on Lilypad"
    }
  end
end
