RSpec.shared_context 'authorization token' do
  let :token do
    Devise::JWT::TestHelpers.auth_headers({}, user).fetch 'Authorization'
  end
  header 'Authorization', :token
end
