class Crawler::UsersController < ActionController::Base
  skip_before_action :track_ahoy_visit
  def show
    @user = User.find params[:id]
    image = @user.avatar

    set_meta_tags og: {
      image: image,
      url: crawler_user_url,
      description: @user.first_name,
      title: "Plan a playdate with #{@user.first_name} on Lilypad"
    }
  end
end
