require 'ostruct'

namespace :import do
  desc 'Import users from people.json from old app'
  task :people_json, [:path_to_json] => [:environment] do |_t, args|
    date_format_year_last = '%m/%d/%Y'
    date_format_year_first = '%Y/%m/%d'

    created_user_emails = []

    path_to_json = Rails.root.join args[:path_to_json]
    json = JSON.parse File.read(path_to_json)
    json = json.map { |u| u.deep_transform_keys!(&:underscore) }

    json.each do |user_attrs|
      u = OpenStruct.new(user_attrs)
      email = u.email.downcase
      ph = u.phone || ''
      ph = ph.gsub(/\D/, '')
      area_code = ph[0..2]
      phone_number = ph[3..-1]

      child_attrs = u.children.map do |c|
        unless c['birthday'].present? &&
               c['name'] &&
               !c['name'].empty?
          next
        end

        bday = c['birthday'].tr('-', '/')
        begin
          bday = DateTime.strptime(bday, date_format_year_first)
        rescue
          bday = DateTime.strptime(bday, date_format_year_last)
        end

        {
          first_name: c['name'],
          birthday: bday
        }
      end.compact

      # skip user who already exists
      user = User.find_by(
        email: email
      )

      if user&.id
        next
      else
        user = User.create!(
          email: email,
          first_name: u.name,
          last_name: u.last_initial,
          facebook_uid: u.fbid,
          phone_area_code: area_code,
          phone_number: phone_number,
          activities: u.activities,
          latitude: (u.location && u.location['lat']) || '',
          longitude: (u.location && u.location['lng']) || '',
          available_mornings: u.availability.include?('7to3'),
          available_afternoons: u.availability.include?('3to7'),
          available_evenings: u.availability.include?('after7'),
          available_weekends: u.availability.include?('weekends'),
          children_attributes: child_attrs,
          # fake a password
          password: SecureRandom.base64(8)
        )

        created_user_emails << user.email
      end
    end
  end
end
