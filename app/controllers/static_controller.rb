class StaticController < ApplicationController
  def index
    @token, = current_user.present? ? Warden::JWTAuth::UserEncoder.new.call(current_user, :user, nil) : [nil]
  end
end
