require 'rails_helper'

RSpec.describe Message do
  describe 'scopes' do
    describe 'with_participants' do
      let!(:user_1) { FactoryBot.create(:user) }
      let!(:user_2) { FactoryBot.create(:user) }
      let!(:twilio_session) { FactoryBot.create(:twilio_session, initiator: user_1, client: user_2) }
      let!(:message_from_1) do
        FactoryBot.create(:message, sender: user_1, receiver: user_2, cc_twilio_session: twilio_session)
      end
      let!(:message_from_2) do
        FactoryBot.create(:message, sender: user_2, receiver: user_1, cc_twilio_session: twilio_session)
      end

      it 'returns messages where the user was the sender or the receiver, regardless of the order of participant ids' do
        msgs = described_class.with_participants(user_1.id, user_2.id)
        expect(msgs).to include message_from_1
        expect(msgs).to include message_from_2
      end
    end
  end
end
