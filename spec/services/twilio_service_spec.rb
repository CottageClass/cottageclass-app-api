require 'rails_helper'

RSpec.describe TwilioService do
  describe 'proxy_session_for' do
    let!(:fake_twilio_client) { instance_double(Twilio::REST::Client) }
    let!(:service) { described_class.new(fake_twilio_client) }
    let!(:p1) { FactoryBot.create(:user) }
    let!(:p2) { FactoryBot.create(:user) }

    context 'when an active session for the participants exists' do
      let!(:active_session_p1_p2) do
        FactoryBot.create(:twilio_session, initiator: p1, client: p2)
      end

      it 'returns the active session' do
        sess = service.proxy_session_for(initiator: p1, client: p2)
        expect(sess).to eq active_session_p1_p2
        expect(TwilioSession.count).to eq 1
      end
    end

    context 'when a session for the participants exists, but is not active' do
      let!(:inactive_session_p1_p2) do
        FactoryBot.create(:twilio_session, initiator: p1, client: p2, last_action_at: 2.weeks.ago)
      end

      before do
        twilio_session_response = OpenStruct.new(sid: 'KSXXXX1', unique_name: 'demo')
        twilio_participant_response1 = OpenStruct.new(sid: 'KPXXXX1')
        twilio_participant_response2 = OpenStruct.new(sid: 'KPXXXX2')
        allow(service).to receive(:create_twilio_proxy_session!).and_return twilio_session_response
        allow(service).to receive(:add_participant_to_session!).and_return twilio_participant_response1
        allow(service).to receive(:add_participant_to_session!).and_return twilio_participant_response2
      end

      it 'creates a new session and adds the participants to it' do
        expect(service).to receive(:create_twilio_proxy_session!)
        expect(service).to receive(:add_participant_to_session!).with(anything, p1.name, anything)
        expect(service).to receive(:add_participant_to_session!).with(anything, p2.name, anything)

        sess = service.proxy_session_for(initiator: p1, client: p2)

        expect(TwilioSession.count).to eq 2
        expect(sess).not_to eq inactive_session_p1_p2
        expect(sess.initiator).to eq p1
        expect(sess.client).to eq p2
      end
    end
  end
end
