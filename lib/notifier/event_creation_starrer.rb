class Notifier::EventCreationStarrer < Notifier::UserBase
  def email
    dump_mail_template_parameters name: 'EventCreationStarrer.json'
    response = @sendgrid_client.send_mail to: [@user],
                                          from: @sender_email,
                                          template_id: sendgrid_template[:event_creation_starrer],
                                          parameters: mail_template_parameters.deep_stringify_keys

    (response.try(:headers) || {}).dig('x-message-id').try :first
  end

  def message
    Rails.logger.debug format('method not implemented: %s', __method__)
    nil
  end

  protected

  def display_age(age_in_months, month_unit)
    if age_in_months < 24
      age_in_months.to_s + ' ' + month_unit + (age_in_months > 1 ? 's' : '')
    else
      (age_in_months / 12).to_s
    end
  end

  def mail_template_parameters
    return if @user.place.nil? || @notifiable_user.place.nil?

    distance = @user.place.distance_to(@notifiable_user.place).round(1).to_s

    ages = @notifiable_user.child_ages_in_months
    if ages.empty?
      kids_ages_sentence_string = 'no kids'
      kids_ages_standalone_string = 'no kids'
    elsif ages.length == 1
      kids_ages_sentence_string = '1 kid age ' + display_age(ages[0], 'month')
      kids_ages_standalone_string = '1 Kid age ' + display_age(ages[0], 'mo')
    else
      display_ages = ages.map { |age| display_age(age, 'mo') }
      and_join_ages = display_ages.slice(0, display_ages.length - 1).join(', ') + ' and ' + display_ages[-1]
      kids_ages_sentence_string = ages.count.to_s + ' kids ages ' + and_join_ages
      kids_ages_standalone_string = ages.count.to_s + ' kids ages ' + and_join_ages
    end

    suggested_user_hash = {
      first_name: @notifiable_user.first_name,
      last_initial: @notifiable_user.last_name[0].capitalize,
      distance: distance + ' miles',
      kids_ages_sentence_string: kids_ages_sentence_string,
      kids_ages_standalone_string: kids_ages_standalone_string,
      bio: truncated_bio,
      bio_truncated: bio_truncated?,
      avatar: @notifiable_user.avatar,
      link: ENV['LINK_HOST'] + '/users/' + @notifiable_user.id.to_s
    }

    super.update notifiable_user: suggested_user_hash
  end
end
