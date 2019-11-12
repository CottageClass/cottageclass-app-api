class Notifier::UserSuggestion < Notifier::UserBase
  def email
    dump_mail_template_parameters name: 'UserSuggestion.json'
    response = @sendgrid_client.send_mail to: [@user],
                                          from: @sender_email,
                                          template_id: sendgrid_template[:user_suggestion],
                                          parameters: mail_template_parameters.deep_stringify_keys

    (response.try(:headers) || {}).dig('x-message-id').try :first
  end

  def message
    Rails.logger.debug format('method not implemented: %s', __method__)
    nil
  end

  protected

  def mail_template_parameters
    return if @user.place.nil? || @notifiable_user.place.nil?

    suggested_user_hash = {
      first_name: @notifiable_user.first_name.capitalize,
      last_initial: @notifiable_user.last_initial,
      distance: distance_with_units,
      short_distance: distance_with_units_short,
      kids_ages_standalone_string: kids_ages_standalone_string,
      kids_ages_sentence_string: kids_ages_sentence_string,
      neighborhood: @notifiable_user.place.neighborhood,
      bio: truncated_bio,
      bio_truncated: bio_truncated?,
      avatar: @notifiable_user.avatar,
      link: link
    }

    super.update suggested_user: suggested_user_hash
  end
end
