require 'net/http'
require 'json'
require 'uri'

namespace :users do
  desc 'Remove broken image links resulting from expired fb CDN URLs'
  task remove_broken_images: :environment do
    puts "Finding images on #{User.count} users"

    ActiveRecord::Base.transaction do
      User.all.each do |user|
        images = user.images
        next if images.empty?

        new_images = []
        images.each do |image_url|
          uri = URI.parse(image_url)
          if (valid_uri? uri) && (valid_response? uri)
            new_images = new_images << image_url
          else
            puts 'invalid image found: ' + image_url + '. For user : ' + user.id.to_s
          end
        end
        user.update_columns images: new_images
      end
    end

    puts 'Done removing broken links'
  end

  desc 'Find any facebook images that are valid and move to cloudinary'
  task move_facebook_images_to_cloudinary: :environment do
    ActiveRecord::Base.transaction do
      User.all.each do |user|
        images = user.images
        next if images.empty?

        new_images = []
        images.each do |image_url|
          uri = URI.parse(image_url)
          if (valid_uri? uri) && (facebook_image? image_url) && (valid_response? uri)
            puts 'valid facebook image found: ' + image_url
            cloudinary_image_url = upload_to_cloudinary image_url
            puts 'uploaded to cloudinary: ' + cloudinary_image_url
            new_images = new_images << cloudinary_image_url
          else
            new_images = new_images << image_url
          end
        end
        user.update_columns images: new_images
      end
    end
  end
end

def valid_uri?(uri)
  !uri.host.nil?
rescue URI::InvalidURIError
  false
end

def valid_response?(uri)
  Net::HTTP.get_response(uri).code == '200'
end

def facebook_image?(url)
  url.include? 'scontent'
end

def cloudinary_upload_url
  "https://api.cloudinary.com/v1_1/#{ENV['CLOUDINARY_CLOUD_NAME']}/image/upload"
end

def upload_to_cloudinary(url)
  request = Net::HTTP.post(URI(cloudinary_upload_url),
                           { file: url, upload_preset: 'user_images' }.to_json,
                           'Content-Type' => 'application/json')
  response_data = JSON.parse request.body
  response_data['secure_url']
end
