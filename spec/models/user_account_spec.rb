require "rails_helper"

RSpec.describe UserAccount, type: :model do
  let(:user) { create(:user_account) }

  describe "register multiple requests" do
    subject { user.is_exceed? }

    context "when user_account have four requests" do
      before { create_list(:request, 4) }

      it { is_expected.to be(false) }
    end

    context "when user_account have five requests" do
      before { create_list(:request, 5) }

      it { is_expected.to be(false) }
    end
  end

  describe "verify that the password is correct" do
    subject { user.authenticate?(password) }

    context "when the correct password is entered" do
      let(:password) { "password" }

      it { is_expected.to be(true) }
    end

    context "when the wrong password is entered" do
      let(:password) { "invalid_password" }

      it { is_expected.to be(false) }
    end
  end
end
