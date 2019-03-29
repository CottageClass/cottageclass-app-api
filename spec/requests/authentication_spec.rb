require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.describe 'authentication' do
  let(:user) { FactoryBot.create :user }

  ###################
  ## login request ##
  ###################
  describe 'sign in with POST /users/sign_in', type: :request do
    let(:url) { '/users/sign_in' }
    let(:params) do
      {
        user: {
          email: user.email,
          password: user.password
        }
      }
    end

    context 'when params are correct' do
      before do
        post url, params: params
      end

      it 'returns 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns JTW token in authorization header' do
        expect(response.headers['Authorization']).to be_present
      end

      it 'returns valid JWT token' do
        decoded_token = decoded_jwt_token_from_response(response)
        expect(decoded_token.first['sub']).to be_present
      end
    end

    context 'when login params are incorrect' do
      before { post url }

      it 'returns unathorized status' do
        expect(response.status).to eq 401
      end
    end
  end

  ###################
  ## logout request #
  ###################
  describe 'logout with DELETE /sign_out', type: :request do
    let(:url) { '/users/sign_out' }

    it 'returns 204, no content' do
      delete url
      expect(response).to have_http_status(:no_content)
    end
  end

  #####################
  ## sign up request ##
  #####################

  describe 'register with POST /users', type: :request do
    let(:url) { '/users' }
    let(:params) do
      {
        user: {
          email: 'user@example.com',
          password: 'password'
        }
      }
    end

    context 'when user is unauthenticated' do
      before { post url, params: params }

      it 'returns 200' do
        expect(response.status).to eq 200
      end
    end

    context 'when user already exists' do
      before do
        # register the user twice
        post url, params: params
        post url, params: params
      end

      it 'returns unprocessable entitiy status' do
        expect(response.status).to eq 422
      end

      it 'returns validation errors' do
        puts response.parsed_body
        expect(response.parsed_body['errors']['email']).to eq(['has already been taken'])
      end
    end
  end
end

def decoded_jwt_token_from_response(response)
  token = response.headers['Authorization']
  JWT.decode(token.split(' ')[1], ENV['DEVISE_JWT_SECRET_KEY'])
end
