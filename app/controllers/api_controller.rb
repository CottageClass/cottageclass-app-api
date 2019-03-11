class ApiController < ActionController::API
  ADMIN_WHITELIST = [
    'holmes@cottageclass.com',
    'manisha@cottageclass.com',
    'developer@cottageclass.com',
    'asa@cottageclass.com',
  ]

  before_action do
    pp "REQ BODY"
    pp params
    pp request.body
  end

  def require_admin!
    redirect_to root_path unless ADMIN_WHITELIST.include?(current_user.email)
  end
end
