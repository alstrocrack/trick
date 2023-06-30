require "rails_helper"

RSpec.describe ApiKey, type: :model do
  let(:user) { create(:user_account, id: 0) }
  let(:guest) { GuestUser.new(1) }

  it "get user's api_key" do
    expect(ApiKey.get_user_api_key(user.id)).to eq("user-0")
  end

  it "get guest's api_key" do
    expect(ApiKey.get_guest_api_key(guest.id)).to eq("guest-1")
  end
end
