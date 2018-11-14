require 'rails_helper'
require 'ostruct'
require 'ffaker'

namespace :import do
  desc "Import users from people.json from old app"
  task :people_json, [:path_to_json] => [:environment] do |t, args|
    date_format_year_last = "%m/%d/%Y"
    date_format_year_first = "%Y/%m/%d"

    created_network_codes = []

    path_to_json = File.join(Rails.root.to_s, args[:path_to_json])
    json = JSON.parse(File.read(path_to_json))
    json = json.map {|u| u.deep_transform_keys!(&:underscore) }

    json.each do |user_attrs|
      u = OpenStruct.new(user_attrs)
      email = u.email || FFaker::Internet.email
      ph = u.phone || ""
      ph = ph.gsub(/\D/, '')
      area_code = ph[0..2]
      phone_number = ph[3..-1]

      child_attrs = u.children.map do |c|
        unless c['birthday'] &&
            c['birthday'].length > 0 &&
            c['name'] &&
            c['name'].length > 0
          next
        end

        bday = c['birthday'].gsub(/-/, '/')
        begin
          bday = DateTime.strptime(bday, date_format_year_first)
        rescue
          bday = DateTime.strptime(bday, date_format_year_last)
        end

        {
          first_name: c['name'],
          birthday: bday,
        }
      end.compact

      # skip user who already exists
      user = User.find_by(
        email: email,
      )

      if user && user.id
        next
      else
        user = User.create!(
          email: email,
          first_name: u.name,
          last_name: u.last_initial,
          facebook_id: u.fbid,
          phone_area_code: area_code,
          phone_number: phone_number,
          network_code: u.networks.first,
          activities: u.activities,
          latitude: (u.location && u.location['lat']) || "",
          longitude: (u.location && u.location['lng']) || "",
          available_mornings: u.availability.include?("7to3"),
          available_afternoons: u.availability.include?("3to7"),
          available_evenings: u.availability.include?("after7"),
          available_weekends: u.availability.include?("weekends"),
          children_attributes: child_attrs,
          # fake a password
          password: SecureRandom.base64(15),
        )

        created_network_codes << user.network_code
      end
    end

    created_network_codes = created_network_codes.compact.uniq
    pp "Added Users to #{created_network_codes.length} Network Codes:"
    pp created_network_codes
  end
end
