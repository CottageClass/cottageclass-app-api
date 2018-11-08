require 'rails_helper'

RSpec.describe FacebookTokenController do
  describe 'create' do
    let(:code) { "AQDPRV3gPiXbG_gydEIM11g8IWZCANADbnnt96v-LS0cb0xcnt1X_LTQ2DH3HSChtxgnFKEC6NJWqk6et6RFWWgceW1_VkxaLJGN_ed1sY6eq8PbVGwfkmcNiseVUlSIp67ePx4t63_RqAObSUnXV4AuVI65VNyk6ruQtutHD6B9BYwId8GNLjrnvjCAOmf1J6bp2J7RLjGVPotD-zlAZRfoPhs7PWXeNEkY6Trl_THrjtkosHNkqiM4HmEw0_xqxiNOHaKgMCMN0ZfAg6oN_pGT0S66LL2d-orvXXF_ZN7W80I0s6uz-uvs6cujH_ln8DOCVhwa9UpRkR2sb83Ox2QB" }

    context 'when the user exists' do
      let!(:jeff) { FactoryBot.create(:user, facebook_uid: 1) }

      it 'finds the user via FB ID and issues a JWT' do
        access_token_info = {
          'access_token': 'fake_token',
          'expires_in': 100_000,
        }
        allow(FacebookService).to receive(:get_access_token_info).and_return(access_token_info)
        allow(FacebookService).to receive(:fetch_data).and_return({
          'id' => 1,
          'first_name' => 'Jeff',
          'last_name' => 'Bezos',
          'email' => 'jb@amazon.com',
        })

        expect {
          post :create, params: {facebook_token: {code: code}}
        }.to_not change {
          User.count
        }
        expect(response.status).to eq 201
        expect(response.body).to match(/jwt/)
      end
    end

    context 'when the user logs in for the first time' do
      it 'creates the user, issues a random password, and issues a JWT' do
        access_token_info = {
          'access_token': 'fake_token',
          'expires_in': 100_000,
        }
        allow(FacebookService).to receive(:get_access_token_info).and_return(access_token_info)
        allow(FacebookService).to receive(:fetch_data).and_return({
          'id' => 1,
          'first_name' => 'Jeff',
          'last_name' => 'Bezos',
          'email' => 'jb@amazon.com',
        })

        expect {
          post :create, params: {facebook_token: {code: code}}
        }.to change {
          User.count
        }.from(0).to(1)
        expect(response.status).to eq 201
        expect(response.body).to match(/jwt/)

      end
    end

    it 'authenticates the user based on the code'
  end
end
