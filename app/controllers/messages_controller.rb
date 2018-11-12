class MessagesController < ApplicationController
  before_action :authenticate_user

  def create
  end


  private

  def message_params
    params.require(:message).permit(
      :content,
    )
  end
end
