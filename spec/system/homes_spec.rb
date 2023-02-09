require "rails_helper"

RSpec.describe "Homes", type: :system do
  context "as a registered user" do
    it "responds successfully and return correct requests" do
      user_account = FactoryBot.create(:user_account)
      sign_in_with(user_account.email, "password")

      visit root_path
    end
  end
end
