class Notifier::Base
  def initialize(user:)
    @user = user
  end

  def transmit
    message
    email
  end

  def message
    Rails.logger.debug format('method not implemented yet: %s', __method__)
  end

  def email
    Rails.logger.debug format('method not implemented yet: %s', __method__)
  end
end
