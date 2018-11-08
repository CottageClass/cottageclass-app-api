require 'rails_helper'

RSpec.describe TwilioService do
  describe 'proxy_session_for' do
    let!(:fake_twilio_client) { instance_double(Twilio::REST::Client) }
    let!(:service) { TwilioService.new(fake_twilio_client) }
    let!(:p1) { FactoryBot.create(:user) }
    let!(:p2) { FactoryBot.create(:user) }

    context 'when an active session for the participants exists' do
      let!(:active_session_p1_p2) {
        FactoryBot.create(:twilio_session, participant_ids: [p1.id, p2.id])
      }
      it 'returns the active session' do
        sess = service.proxy_session_for(sender: p1, receiver: p2)
        expect(sess).to eq active_session_p1_p2
        expect(TwilioSession.count).to eq 1
      end
    end

    context 'when a session for the participants exists, but is not active' do
      let!(:inactive_session_p1_p2) {
        FactoryBot.create(:twilio_session, participant_ids: [p1.id, p2.id], last_action_at: 3.days.ago)
      }

      before(:each) do
        twilio_session_response = OpenStruct.new(sid: 1, unique_name: 'demo')
        allow(service).to receive(:create_twilio_proxy_session!).and_return twilio_session_response
      end

      it 'creates a new session and adds the participants to it' do
        expect(service).to receive(:create_twilio_proxy_session!)
        expect(service).to receive(:add_participant_to_session!).with(anything, p1.name, anything)
        expect(service).to receive(:add_participant_to_session!).with(anything, p2.name, anything)

        sess = service.proxy_session_for(sender: p1, receiver: p2)

        expect(TwilioSession.count).to eq 2
        expect(sess).to_not eq inactive_session_p1_p2
        expect(sess.participant_ids).to match_array [p1.id, p2.id].map(&:to_s)
      end
    end
  end
end
