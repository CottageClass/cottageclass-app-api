require 'rails_helper'

RSpec.describe 'Twilio proxy messages', type: :request do
  describe 'create' do
    let(:sender)          { FactoryBot.create(:user) }
    let(:receiver)        { FactoryBot.create(:user) }
    let(:twilio_session)  { OpenStruct.new(sid: "KCXXXX1", unique_name: 'demo', date_expiry: '2022-07-30T20:00:00Z') }
    let(:twilio_msg_obj)  { OpenStruct.new(session_sid: 'KCXXXX1', sid: 'KIXXXX', data: 'message body') }

    before(:each) do
      twilio_participant_response_1 = OpenStruct.new(sid: "KPXXXX1")
      twilio_participant_response_2 = OpenStruct.new(sid: "KPXXXX2")
      allow_any_instance_of(TwilioService).to receive(:create_twilio_proxy_session!)
        .and_return twilio_session
      allow_any_instance_of(TwilioService).to receive(:add_participant_to_session!)
        .and_return twilio_participant_response_1
      allow_any_instance_of(TwilioService).to receive(:add_participant_to_session!)
        .and_return twilio_participant_response_2
      allow_any_instance_of(TwilioService).to receive(:send_twilio_message_to_participant!)
        .and_return twilio_msg_obj
    end

    it 'requires authorization' do
      post proxy_sessions_path(receiver)
      expect(response.status).to eq 401
    end

    it 'creates a new session' do
      expect_any_instance_of(TwilioService).to receive(:create_twilio_proxy_session!)

      post proxy_sessions_path(receiver), headers: authenticated_header(sender)

      expect(TwilioSession.count).to equal 1
      expect(response.status).to eq 201
    end

    it 'adds both participants to the conversation' do
      expect_any_instance_of(TwilioService).to receive(:add_participant_to_session!)
        .with("KCXXXX1", sender.name, sender.phone(true))
      expect_any_instance_of(TwilioService).to receive(:add_participant_to_session!)
        .with("KCXXXX1", receiver.name, receiver.phone(true))

      post proxy_sessions_path(receiver), headers: authenticated_header(sender)

      expect(TwilioSession.first.sender_id).to eq sender.id
      expect(TwilioSession.first.receiver_id).to eq receiver.id
      expect(response.status).to eq 201
    end

    context 'when a session already exists for the participants' do
      before(:each) do
        TwilioSession.create!(
          last_action_at: DateTime.now,
          sender: sender,
          receiver: receiver,
          twilio_sid: 'KCXXXX1',
          twilio_sid_receiver: 'KPXXXX2',
        )
      end

      it 'finds the session instead of creating a new one' do
        expect_any_instance_of(TwilioService).to_not receive(:create_twilio_proxy_session!)

        expect {
          post proxy_sessions_path(receiver), headers: authenticated_header(sender)
        }.to_not change {
          TwilioSession.count
        }

        expect(response.status).to eq 201
      end

      it 'does not add participants to the conversation' do
        expect_any_instance_of(TwilioService).to_not receive(:add_participant_to_session!)

        post proxy_sessions_path(receiver), headers: authenticated_header(sender)

        expect(response.status).to eq 201
      end
    end
  end
end
