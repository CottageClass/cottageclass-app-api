RSpec.shared_context 'authorization token' do
  let(:token) { Knock::AuthToken.new(payload: { sub: user.id }).token }
  header 'Authorization', :token
end
