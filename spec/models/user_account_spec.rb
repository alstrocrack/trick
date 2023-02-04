require "rails_helper"

RSpec.describe UserAccount, type: :model do
  let(:user_account) { FactoryBot.create(:user_account) }

  context "when user_account have four requests" do
    it "returns false" do
      4.times { |n| FactoryBot.create(:request, user_id: user_account.id) }
      expect(user_account.is_exceed?).to be false
    end
  end

  context "when user_account have five requests" do
    it "returns true" do
      5.times { |n| FactoryBot.create(:request, user_id: user_account.id) }
      expect(user_account.is_exceed?).to be true
    end
  end

  context "when the correct password is entered" do
    it "authenticate the user" do
      expect(user_account.authenticate?("password")).to be true
    end
  end

  context "when the wrong password is entered" do
    it "does not authenticate users" do
      expect(user_account.authenticate?("invalid_password")).to be false
    end
  end
end
