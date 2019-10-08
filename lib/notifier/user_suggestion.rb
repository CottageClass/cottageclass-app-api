class Notifier::UserSuggestion < Notifier::Base
  def initialize(user:, body:, suggested_user:)
    super user: user, body: body
    @suggested_user = suggested_user
  end

  def email
    dump_mail_template_parameters name: 'UserSuggestion.json'
    response = @sendgrid_client.send_mail to: [@user],
                                          from: @sender_email,
                                          template_id: ENV.fetch('SENDGRID_TEMPLATE_USER_SUGGESTION'),
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
    return if @user.place.nil? || @suggested_user.place.nil?

    distance = @user.place.distance_to(@suggested_user.place).round(1).to_s
    full_bio = @suggested_user.profile_blurb
    if full_bio
      truncated_bio = full_bio.truncate(260, seperator: /\s/) if full_bio
      bio_truncated = full_bio.length != truncated_bio.length
    else
      truncated_bio = ''
      bio_truncated = false
    end

    ages = @suggested_user.child_ages_in_months
    if ages.length == 1
      kids_ages_standalone_string = 'Child age ' + display_age(ages[0], 'mo')
      kids_ages_sentence_string = 'child is ' + display_age(ages[0], 'month')
    else
      display_ages = ages.map { |age| display_age(age, 'mo') }
      and_join_ages = display_ages.slice(0, display_ages.length - 1).join(', ') + ' and ' + display_ages[-1]
      kids_ages_standalone_string = 'Childen age ' + and_join_ages
      kids_ages_sentence_string = 'children are ' + and_join_ages
    end

    suggested_user_hash = {
      first_name: @suggested_user.first_name,
      last_initial: @suggested_user.last_name[0].capitalize,
      distance: distance + ' miles',
      short_distance: distance + ' mi',
      kids_ages_standalone_string: kids_ages_standalone_string,
      kids_ages_sentence_string: kids_ages_sentence_string,
      neighborhood: @suggested_user.neighborhood,
      bio: truncated_bio,
      bio_truncated: bio_truncated,
      avatar: @suggested_user.avatar,
      link: ENV['LINK_HOST'] + '/users/' + @suggested_user.id.to_s
    }

    super.update suggested_user: suggested_user_hash
  end
end
