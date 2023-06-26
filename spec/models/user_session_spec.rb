require "rails_helper"

RSpec.describe UserSession, type: :model do
  let(:user) { create(:user_account) }
  let(:user_session) { create(:user_session, user_id: user.id) }
  let(:session_token) { "exmaple-session-value" }
  let(:invalid_session_token) { "invalid_token" }

  describe "#authenticate?" do
    context "when valid session_digest" do
      it "return true" do
        expect(user_session.authenticate?(session_token)).to eq true
      end
    end

    context "when invalid session_digest" do
      it "return false" do
        expect(user_session.authenticate?(invalid_session_token)).to eq false
      end
    end
  end
end
