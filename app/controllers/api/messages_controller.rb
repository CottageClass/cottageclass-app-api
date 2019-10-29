class API::MessagesController < API::BaseController
  before_action :authenticate_user!, only: %i[conversations]
end
