require 'rails_helper'

RSpec.describe TwilioSession do
  describe 'callbacks' do
    describe 'ensure_last_action_utc' do
      it 'converts the last_action_at time to utc before saving' do
        yesterday = 1.day.ago.in_time_zone("Tokyo")
        session = TwilioSession.create!(last_action_at: yesterday)

        expect(session.last_action_at.zone).to eq "UTC"
        expect(session.last_action_at.zone).to_not eq "JST"
      end
    end
  end
  describe 'scopes' do
    describe 'live' do
      let!(:active_session_1) { FactoryBot.create(:twilio_session) }
      let!(:active_session_2) { FactoryBot.create(:twilio_session) }
      let!(:inactive_session) { FactoryBot.create(:twilio_session, last_action_at: 1.month.ago) }

      it 'returns sessions with a last_action within 1 day ago' do
        sessions = TwilioSession.live
        expect(sessions).to include(active_session_1, active_session_2)
      end

      it 'does not return sessions with a last_action more than 1 day ago' do
        sessions = TwilioSession.live
        expect(sessions).to_not include(inactive_session)
      end
    end

    describe 'for_users' do
      let!(:p1) { FactoryBot.create(:user) }
      let!(:p2) { FactoryBot.create(:user) }
      let!(:p3) { FactoryBot.create(:user) }
      let!(:session_with_p1) { FactoryBot.create(:twilio_session, participant_ids: [p1.id]) }
      let!(:session_with_p2) { FactoryBot.create(:twilio_session, participant_ids: [p2.id]) }
      let!(:session_with_p1_p2) { FactoryBot.create(:twilio_session, participant_ids: [p1.id, p2.id]) }
      let!(:session_with_p1_p3) { FactoryBot.create(:twilio_session, participant_ids: [p1.id, p3.id]) }

      context 'when only one participant is specified' do
        it 'returns sessions containing the desired participant ID' do
          sessions = TwilioSession.with_participants([p1.id])
          expect(sessions).to include session_with_p1
          expect(sessions).to_not include session_with_p2
          expect(sessions).to include session_with_p1_p2
          expect(sessions).to include session_with_p1_p3
        end
      end

      context 'when two participants are specified' do
        it 'returns sessions containing both desired participant IDs' do
          sessions = TwilioSession.with_participants([p1.id, p2.id])
          expect(sessions).to_not include session_with_p1
          expect(sessions).to_not include session_with_p2
          expect(sessions).to include session_with_p1_p2
          expect(sessions).to_not include session_with_p1_p3
        end
      end

      context 'when more than two participants are specified' do
        # this should be handled by a validation in TwilioSession
        it 'finds no sessions because more than two participants is forbidden' do
          expect {
            FactoryBot.create(:twilio_session, participant_ids: [p1.id, p2.id, p3.id])
          }.to raise_error(/A session can have up to two participants max/)

          sessions = TwilioSession.with_participants([p1.id, p2.id, p3.id])
          expect(sessions.count).to eq 0
        end
      end

      context 'when no participant IDs are specified' do
        it 'returns all sessions' do
          sessions = TwilioSession.with_participants([])
          expect(sessions.count).to eq 4
        end
      end
    end
  end

  describe 'live_session_cutoff' do
    it 'specifies the cutoff time in UTC for correct comparison to the database last_action_at' do
      last_action_time = TwilioSession.live_session_cutoff
      expect(last_action_time.zone).to eq "UTC"
    end
  end
end
