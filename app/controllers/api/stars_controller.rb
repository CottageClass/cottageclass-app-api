class API::StarsController < API::BaseController
  def create
    @star = @starable.stars.new star_params
    @starable.save
  end

  private
    def safe_params
      params.require(:star).permit :starable
    end
end
