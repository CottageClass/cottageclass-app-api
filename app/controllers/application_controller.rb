class ApplicationController < ActionController::Base

  # authentication method for ActiveAdmin
  def authenticate_admin!
    master_pass = ENV['ACTIVE_ADMIN_MASTER_PASS']

    auth_success = authenticate_or_request_with_http_basic("Welcome to CottageClass Admin!") do |name, password|
      name == "admin" && password == master_pass
    end

    if (
        !(master_pass && master_pass.length > 0) ||
        !auth_success
    )
      return false
    end
  end

end
