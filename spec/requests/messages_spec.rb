require 'rails_helper'

RSpec.describe 'Twilio proxy messages', type: :request do
  describe 'create' do
    let(:sender)          { FactoryBot.create(:user) }
    let(:receiver)        { FactoryBot.create(:user) }
    let(:twilio_session)  { OpenStruct.new(sid: "KCXXXX1", unique_name: 'demo', date_expiry: '2022-07-30T20:00:00Z') }
    let(:twilio_msg_obj)  { OpenStruct.new(session_sid: 'KCXXXX1', sid: 'KIXXXX', data: 'message body') }

    before(:each) do
      allow_any_instance_of(TwilioService).to receive(:create_twilio_proxy_session!)
        .and_return twilio_session
      allow_any_instance_of(TwilioService).to receive(:add_participant_to_session!)
        .and_return "sender_sid"
      allow_any_instance_of(TwilioService).to receive(:add_participant_to_session!)
        .and_return "receiver_sid"
      allow_any_instance_of(TwilioService).to receive(:send_message_to_participant!)
        .and_return twilio_msg_obj
    end

    it 'requires authorization' do
      post messages_path(receiver)
      expect(response.status).to eq 401
    end

    it 'creates a new session' do
      expect_any_instance_of(TwilioService).to receive(:create_twilio_proxy_session!)

      post messages_path(receiver), headers: authenticated_header(sender)

      expect(TwilioSession.count).to equal 1
      expect(response.status).to eq 201
    end

    it 'adds both participants to the conversation' do
      expect_any_instance_of(TwilioService).to receive(:add_participant_to_session!)
        .with("KCXXXX1", sender.name, sender.phone(true))
      expect_any_instance_of(TwilioService).to receive(:add_participant_to_session!)
        .with("KCXXXX1", receiver.name, receiver.phone(true))

      post messages_path(receiver), headers: authenticated_header(sender)

      expect(TwilioSession.first.participant_ids.map(&:to_i)).to match_array [sender.id, receiver.id].map(&:to_i)
      expect(response.status).to eq 201
    end

    it 'sends an introductory message to the receiver' do
      expect_any_instance_of(TwilioService).to receive(:send_message_to_participant!)
        .with("KCXXXX1", "receiver_sid", anything)

      post messages_path(receiver), headers: authenticated_header(sender)

      expect(Message.count).to eq 1
      expect(Message.first.sender_id).to eq sender.id
      expect(Message.first.receiver_id).to eq receiver.id
      expect(Message.first.content).to match(/message body/)
      expect(response.status).to eq 201
    end

    context 'when a session already exists for the participants' do
      before(:each) do
        TwilioSession.create!(
          last_action_at: DateTime.now,
          participant_ids: [sender.id, receiver.id],
          twilio_sid: 'KCXXXX',
          twilio_sid_receiver: 'KPXXXXreceiver',
        )
      end

      it 'finds the session instead of creating a new one' do
        expect_any_instance_of(TwilioService).to_not receive(:create_twilio_proxy_session!)

        expect {
          post messages_path(receiver), headers: authenticated_header(sender)
        }.to_not change {
          TwilioSession.count
        }

        expect(response.status).to eq 201
      end

      it 'does not add participants to the conversation' do
        expect_any_instance_of(TwilioService).to_not receive(:add_participant_to_session!)

        post messages_path(receiver), headers: authenticated_header(sender)

        expect(response.status).to eq 201
      end

      # this is up for debate whether it should send a second message
      it '*does* send a second introductory message' do
        expect_any_instance_of(TwilioService).to receive(:send_message_to_participant!)
          .with("KCXXXX", "KPXXXXreceiver", anything)

        post messages_path(receiver), headers: authenticated_header(sender)

        expect(Message.count).to eq 1
        expect(Message.first.sender_id).to eq sender.id
        expect(Message.first.receiver_id).to eq receiver.id
        expect(Message.first.content).to match(/message body/)
        expect(response.status).to eq 201
      end
    end
  end
end
