require 'rails_helper'

RSpec.describe TwilioSession do
  describe 'callbacks' do
    describe 'ensure_last_action_utc' do
      it 'converts the last_action_at time to utc before saving' do
        yesterday = 1.day.ago.in_time_zone('Tokyo')
        session = FactoryBot.create(:twilio_session, last_action_at: yesterday)

        expect(session.last_action_at.zone).to eq 'UTC'
        expect(session.last_action_at.zone).not_to eq 'JST'
      end
    end
  end

  describe 'scopes' do
    describe 'live' do
      let!(:active_session_1) { FactoryBot.create(:twilio_session) }
      let!(:active_session_2) { FactoryBot.create(:twilio_session) }
      let!(:inactive_session) { FactoryBot.create(:twilio_session, last_action_at: 1.month.ago) }

      it 'returns sessions with a last_action within 1 day ago' do
        sessions = described_class.live
        expect(sessions).to include(active_session_1, active_session_2)
      end

      it 'does not return sessions with a last_action more than 1 day ago' do
        sessions = described_class.live
        expect(sessions).not_to include(inactive_session)
      end
    end

    describe 'with_participants' do
      let!(:p1) { FactoryBot.create(:user) }
      let!(:p2) { FactoryBot.create(:user) }
      let!(:p3) { FactoryBot.create(:user) }
      let!(:session_with_p1_p2) { FactoryBot.create(:twilio_session, initiator_id: p1.id, client_id: p2.id) }
      let!(:session_with_p2_p1) { FactoryBot.create(:twilio_session, initiator_id: p2.id, client_id: p1.id) }
      let!(:session_with_p1_p3) { FactoryBot.create(:twilio_session, initiator_id: p1.id, client_id: p3.id) }

      it 'returns sessions containing the sender and receiver, in either order' do
        sessions = described_class.with_participants(p1.id, p2.id)
        expect(sessions).to include session_with_p1_p2
        expect(sessions).to include session_with_p2_p1
        expect(sessions).not_to include session_with_p1_p3
      end
    end
  end

  describe 'live_session_cutoff' do
    it 'specifies the cutoff time in UTC for correct comparison to the database last_action_at' do
      last_action_time = described_class.live_session_cutoff
      expect(last_action_time.zone).to eq 'UTC'
    end
  end
end
