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
    #
  end

  context "as a guest" do
    it "does not display any request" do
      visit root_path
      expect(page).to_not have_content "The set requests"
    end

    it "adds a request" do
      visit root_path
      expect {
        fill_in "home[from]", with: "198.0.0.1"
        fill_in "home[status]", with: 200
        fill_in "home[header]", with: '{ "x-header-item": "abc" }'
        fill_in "home[body]", with: '{ "body": "def" }'

        click_button "Register Request"
      }.to change(Request, :count).by(1)
    end
  end
end
