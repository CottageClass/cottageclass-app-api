RSpec.configure do |config|
  config.before { Faker::UniqueGenerator.clear }
end
