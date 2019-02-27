class StaticController < ApplicationController
  def index
    @token = 'token-set-in-rails'
  end
end
