require "rails_helper"

RSpec.describe GuestUser, type: :model do
  let(:guest_user) { GuestUser.new(1) }
  let!(:api_key) { create(:api_key, owner_id: "guest-#{guest_user.id}") }

  describe "register multiple requests" do
    subject { guest_user.is_exceed? }

    context "when user_account have four requests" do
      before { create_list(:request, 4, user_id: nil, guest_id: guest_user.id) }

      it { is_expected.to be(false) }
    end

    context "when user_account have five requests" do
      before { create_list(:request, 5, user_id: nil, guest_id: guest_user.id) }

      it { is_expected.to be(true) }
    end
  end

  it "gets api_key by instance method" do
    expect(guest_user.get_api_key).to eq(api_key.value)
  end

  it "gets api_key by class method" do
    expect(GuestUser.get_api_key(guest_user.id)).to eq(api_key.value)
  end
end
