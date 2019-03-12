class StaticController < ApplicationController
  def index
    @skip_assets = true
    @token, = current_user.present? ? Warden::JWTAuth::UserEncoder.new.call(current_user, :user, nil) : [nil]
  end
end
