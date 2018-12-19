class API::BaseController < ActionController::API
  include Knock::Authenticable
end
