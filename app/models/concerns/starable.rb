require 'active_support/concern'

module Starable
  extend ActiveSupport::Concern
  included do
    has_many :received_stars, as: :starable, class_name: 'Star', dependent: :destroy, inverse_of: :starable
    has_many :starrers, through: :received_stars, source: :giver
  end

  def starred?(current_user)
    received_stars.where(giver: current_user).present?
  end
end
