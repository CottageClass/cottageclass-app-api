class Notifier::UserBase < Notifier::Base
  def initialize(user:, body:, notifiable_user:)
    super user: user, body: body
    @notifiable_user = notifiable_user
  end
end
