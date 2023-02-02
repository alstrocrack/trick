require "rails_helper"

RSpec.describe UserAccount, type: :model do
  let(:user_account) { FactoryBot.create(:user_account) }

  context "When user_account have four requests" do
    it "returns false" do
      4.times { |n| FactoryBot.create(:request, user_id: user_account.id) }
      expect(user_account.is_exceed?).to be false
    end
  end

  context "When user_account have five requests" do
    it "returns true" do
      5.times { |n| FactoryBot.create(:request, user_id: user_account.id) }
      expect(user_account.is_exceed?).to be true
    end
  end
end
