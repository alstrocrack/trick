require "rails_helper"

RSpec.describe "Homes", type: :system do
  it "login successfully and display user_account's email" do
    user_account = FactoryBot.create(:user_account, email: "example@example.com")

    visit root_path
    expect(page).to_not have_content "example@example.com"

    sign_in_with(user_account.email, "password")
    visit root_path

    expect(page).to have_content "example@example.com"
  end

  context "as a registered user" do
  end
end
