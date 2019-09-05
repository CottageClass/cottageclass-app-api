class API::BaseController < ActionController::API
  include ActionController::MimeResponds

  skip_before_action :track_ahoy_visit

  respond_to :json
end
