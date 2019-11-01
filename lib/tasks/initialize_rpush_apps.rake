namespace :push do
  desc 'Create apps for push notifications'
  task create_rpush_apps: :environment do |_t|
    Rpush::Apns2::App.all.each(&:destroy)
    Rpush::Apns::App.all.each(&:destroy)
    ActiveRecord::Base.transaction do
      apns_app = Rpush::Apns2::App.new
      apns_app.name = 'lilypad-ios'
      apns_app.certificate = File.read(ENV['PATH_TO_APNS_CERTIFICATE'])
      apns_app.environment = ENV['RAILS_ENV']
      apns_app.password = ENV['APNS_CERTIFICATE_PASSWORD']
      apns_app.team_id = ENV['APPLE_TEAM_ID']
      apns_app.bundle_id = ENV['APNS_BUNDLE_ID']
      apns_app.connections = 1
      apns_app.save!

      firebase_app = Rpush::Gcm::App.new
      firebase_app.name = 'lilypad-firebase'
      firebase_app.auth_key = ENV['FIREBASE_AUTH_KEY']
      firebase_app.connections = 1
      firebase_app.save!
    end
  end
end
