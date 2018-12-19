RSpec.shared_context 'json headers' do
  header 'Content-Type', 'application/json'
  header 'Accept', 'application/json'

  let(:raw_post) { params.to_json }
end
