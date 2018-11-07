require 'rails_helper'

RSpec.describe TwilioService do
  describe 'proxy_session_for' do
    it 'creates a new session with the participants' do
      sender = FactoryBot.create(:user)
      receiver = FactoryBot.create(:user)
      twilio_session = OpenStruct.new(sid: 1, unique_name: 'demo')
      twilio_service = instance_double(TwilioService, create_twilio_proxy_session!: twilio_session)
      allow(TwilioService).to receive(:new).and_return twilio_service

      post messages_path(receiver)

      expect(twilio_service).to have_received(:create_twilio_proxy_session!)
      expect(TwilioSession.count).to equal 1
      expect(TwilioSession.first.participant_ids).to include [sender.id, receiver.id]
      expect(response.status).to eq 201
    end
  end
end
