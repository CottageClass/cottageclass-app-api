# seed the local database with some fake users and associated data
require 'faker'

(1..50).each do |tag|
  first_name = Faker::Name.unique.first_name
  last_name = Faker::Name.unique.last_name
  hash = {
    email: "#{first_name}@cottageclass.com",
    password: first_name,
    first_name: first_name,
    last_name: last_name,
    avatar: "https://picsum.photos/id/#{tag}/200/300",
    apartment_number: nil,
    neighborhood: 'Biotech Park Area',
    time_zone: 'America/New_York',
    created_at: '2019-06-12 12:42:02',
    updated_at: '2019-06-12 12:42:56',
    street_number: tag,
    route: 'Orne Street',
    locality: 'Worcester',
    admin_area_level_1: 'Massachusetts',
    admin_area_level_2: 'Worcester County',
    postal_code: '01605',
    phone_area_code: '609',
    phone_number: '2164398',
    country: 'United States',
    phone_country_code: '1',
    activities: [],
    available_mornings: nil,
    available_afternoons: nil,
    available_evenings: nil,
    available_weekends: nil,
    facebook_access_token: nil,
    fb_access_token_expires_at: '2019-06-12 12:42:01',
    profile_blurb: Faker::Lorem.paragraph(2, true, 4),
    images: [],
    languages: ['ab'],
    job_position: Faker::Job.title,
    employer: Faker::Company.name,
    school: nil
  }
  user = User.new(hash)

  # add some children
  children = []

  Random.rand(0..3).times do
    children << Child.new(
      first_name: Faker::Name.unique.first_name,
      birthday: Faker::Time.between(17.years.ago, Time.zone.today, :midnight)
    )
  end
  user.children = children
  next unless user.save

  # add some events
  Random.rand(0..3).times do
    start_time = Faker::Time.between(1.week.ago, Time.zone.today + 2.weeks, :day)
    duration = Random.rand(1..4).hours
    event_series = user.event_series.build(
      name: Faker::Lorem.paragraph(2, true, 4),
      starts_at: start_time,
      start_date: start_time,
      ends_at: start_time + duration,
      repeat_for: Random.rand(1..1),
      interval: 1
    )
    event_series.save
  end
end
