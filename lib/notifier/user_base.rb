class Notifier::UserBase < Notifier::Base
  def initialize(user:, body:, notifiable_user:)
    super user: user, body: body
    @notifiable_user = notifiable_user
  end

  def full_bio
    @notifiable_user.profile_blurb
  end

  def truncated_bio
    full_bio.present? ? full_bio&.truncate(260, seperator: /\s/) : ''
  end

  def bio_truncated?
    full_bio.present? ? full_bio.length != truncated_bio.length : false
  end

  def distance_with_units
    distance + ' miles'
  end

  def distance_with_units_short
    distance + ' mi'
  end

  def ages
    @notifiable_user.child_ages_in_months
  end

  def distance
    return '' if @user.place.nil? || @notifiable_user.place.nil?

    @user.place.distance_to(@notifiable_user.place).round(1).to_s
  end

  def kids_ages_sentence_string
    if ages.empty?
      'no kids'
    elsif ages.length == 1
      'kid is ' + display_age(ages[0], 'month')
    else
      'kids are ' + and_join_ages
    end
  end

  def kids_ages_count_string
    if ages.empty?
      'no kids'
    elsif ages.length == 1
      '1 kid age ' + display_age(ages[0], 'month')
    else
      and_join_ages = display_ages.slice(0, display_ages.length - 1).join(', ') + ' and ' + display_ages[-1]
      ages.count.to_s + ' kids ages ' + and_join_ages
    end
  end

  def display_ages
    ages.map { |age| display_age(age, 'mo') }
  end

  def kids_ages_standalone_string
    if ages.empty?
      'no kids'
    elsif ages.length == 1
      'Kid age ' + display_age(ages[0], 'mo')
    else
      'Kids age ' + and_join_ages
    end
  end

  def and_join_ages
    display_ages.slice(0, display_ages.length - 1).join(', ') + ' and ' + display_ages[-1]
  end

  def link
    ENV['LINK_HOST'] + '/users/' + @notifiable_user.id.to_s
  end

  def chat_link
    ENV['LINK_HOST'] + '/chat/' + @notifiable_user.id.to_s
  end

  def display_age(age_in_months, month_unit)
    if age_in_months < 24
      age_in_months.to_s + ' ' + month_unit + (age_in_months > 1 ? 's' : '')
    else
      (age_in_months / 12).to_s
    end
  end
end
