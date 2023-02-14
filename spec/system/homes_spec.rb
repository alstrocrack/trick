require "rails_helper"

RSpec.describe "Homes", type: :system do
  it "logins successfully and displays user_account's email" do
    user_account = FactoryBot.create(:user_account, email: "example@example.com")
    visit root_path
    expect(page).to_not have_content "example@example.com"
    sign_in_with(user_account.email, "password")
    visit root_path
    expect(page).to have_content "example@example.com"
  end

  it "registers the request correctly" do
    visit root_path
    expect {
      fill_in "home[from]", with: "198.0.0.1"
      fill_in "home[status]", with: 200
      fill_in "home[header]", with: '{ "x-header-item": "abc" }'
      fill_in "home[body]", with: '{ "body": "def" }'
      click_button "Register Request"
    }.to change(Request, :count).by(1)
    expect(page).to have_content "The set requests"
    expect(page).to have_content "abc"
    expect(page).to have_content "def"
  end

  it "does not display any request When the page is first opened" do
    visit root_path
    expect(page).to_not have_content "The set requests"
  end

  context "as a guest user" do
    it "displays the guest-user-id after successful registration if the request is registered as a guest user" do
      visit root_path
      fill_in "home[from]", with: "198.0.0.1"
      fill_in "home[status]", with: 200
      fill_in "home[header]", with: '{ "x-header-item": "abc" }'
      fill_in "home[body]", with: '{ "body": "def" }'
      click_button "Register Request"
      expect(page).to have_content "guest: "
      expect(page).to_not have_content "user: "
    end
  end
end
