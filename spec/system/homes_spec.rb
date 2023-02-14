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
    expect { register_request_with("198.0.0.1", 200, '{ "x-header-item": "abc" }', '{ "body": "def" }') }.to change(Request, :count).by(1)
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
      register_request_with("198.0.0.1", 200, '{ "x-header-item": "abc" }', '{ "body": "def" }')
      expect(page).to have_content "guest: "
      expect(page).to_not have_content "user: "
    end
  end
end
