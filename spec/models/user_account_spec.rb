require "rails_helper"

RSpec.describe UserAccount, type: :model do
  let(:user) { create(:user_account) }
  let!(:api_key) { create(:api_key, owner_id: "user-#{user.id}") }

  describe "register multiple requests" do
    subject { user.is_exceed? }

    context "when user_account have four requests" do
      before { create_list(:request, 4, user_id: user.id, guest_id: nil) }

      it { is_expected.to be(false) }
    end

    context "when user_account have five requests" do
      before { create_list(:request, 5, user_id: user.id, guest_id: nil) }

      it { is_expected.to be(true) }
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

  it "gets api_key by instance method" do
    expect(user.get_api_key).to eq(api_key.value)
  end

  it "gets api_key by class method" do
    expect(UserAccount.get_api_key(user.name)).to eq(api_key.value)
  end
end
