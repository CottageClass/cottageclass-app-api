require 'rails_helper'

RSpec.describe 'Twilio proxy messages', type: :request do
  describe 'create' do
    let(:sender)          { FactoryBot.create(:user) }
    let(:receiver)        { FactoryBot.create(:user) }
    let(:twilio_session)  { OpenStruct.new(sid: 'KCXXXX1', unique_name: 'demo', date_expiry: '2022-07-30T20:00:00Z') }
    let(:twilio_msg_obj)  do
      OpenStruct.new(session_sid: 'KCXXXX1',
                     sid: 'KIXXXX',
                     data: { 'body': 'message body' }.to_json)
    end
    let(:post_data) { { twilio_session: { request_message: 'request', acknowledgment_message: 'ack' } } }

    let :headers do
      {
        'ACCEPT': 'application/json',
        'HTTP_ACCEPT': 'application/json'
      }
    end

    before do
      twilio_participant_response1 = OpenStruct.new(sid: 'KPXXXX1')
      twilio_participant_response2 = OpenStruct.new(sid: 'KPXXXX2')
      allow_any_instance_of(TwilioService).to receive(:create_twilio_proxy_session!)
        .and_return twilio_session
      allow_any_instance_of(TwilioService).to receive(:add_participant_to_session!)
        .and_return twilio_participant_response1
      allow_any_instance_of(TwilioService).to receive(:add_participant_to_session!)
        .and_return twilio_participant_response2
      allow_any_instance_of(TwilioService).to receive(:send_twilio_message_to_participant!)
        .and_return twilio_msg_obj
    end

    it 'requires authorization' do
      post proxy_sessions_path(receiver), params: post_data, headers: headers
      expect(response.status).to eq 401
    end

    it 'creates a new session' do
      expect_any_instance_of(TwilioService).to receive(:create_twilio_proxy_session!)

      post proxy_sessions_path(receiver), params: post_data, headers: authenticated_header(sender)

      expect(TwilioSession.count).to equal 1
      expect(response.status).to eq 201
    end

    it 'adds both participants to the conversation' do
      expect_any_instance_of(TwilioService).to receive(:add_participant_to_session!)
        .with('KCXXXX1', sender.name, sender.phone(true))
      expect_any_instance_of(TwilioService).to receive(:add_participant_to_session!)
        .with('KCXXXX1', receiver.name, receiver.phone(true))

      post proxy_sessions_path(receiver), params: post_data, headers: authenticated_header(sender)

      expect(TwilioSession.first.initiator_id).to eq sender.id
      expect(TwilioSession.first.client_id).to eq receiver.id
      expect(response.status).to eq 201
    end

    context 'when a session already exists for the participants' do
      before do
        TwilioSession.create!(
          last_action_at: DateTime.current,
          initiator: sender,
          client: receiver,
          twilio_sid: 'KCXXXX1',
          twilio_sid_client: 'KPXXXX2'
        )
      end

      it 'finds the session instead of creating a new one' do
        expect_any_instance_of(TwilioService).not_to receive(:create_twilio_proxy_session!)

        expect do
          post proxy_sessions_path(receiver), params: post_data, headers: authenticated_header(sender)
        end.not_to change(TwilioSession, :count)

        expect(response.status).to eq 201
      end

      it 'does not add participants to the conversation' do
        expect_any_instance_of(TwilioService).not_to receive(:add_participant_to_session!)

        post proxy_sessions_path(receiver), params: post_data, headers: authenticated_header(sender)

        expect(response.status).to eq 201
      end
    end
  end
end
