class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  # authentication method for ActiveAdmin
  def authenticate_admin!
    master_pass = ENV['ACTIVE_ADMIN_MASTER_PASS']

    auth_success = authenticate_or_request_with_http_basic('Welcome to CottageClass Admin!') do |name, password|
      name == 'admin' && password == master_pass
    end

    return false if master_pass.blank? || !auth_success
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit :sign_up, keys: %i[first_name last_name]
  end
end
