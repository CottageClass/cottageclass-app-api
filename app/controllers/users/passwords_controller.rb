class Users::PasswordsController < Devise::PasswordsController
  def after_sending_reset_password_instructions_path_for(_)
    edit_user_password_path
  end
end
