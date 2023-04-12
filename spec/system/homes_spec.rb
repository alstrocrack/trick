require "rails_helper"

RSpec.describe "Homes", type: :system do
  request_header = '{ "x-header-item": "abc" }'
  request_body = '{ "body": "def" }'

  it "logins successfully and displays user_account's name" do
    user_account = FactoryBot.create(:user_account, name: "example1")
    visit root_path
    expect(page).to have_link("Login", href: "/login")
    expect(page).to_not have_content "example1"
    sign_in_with(user_account.email, "password")
    expect(page).to have_content "example1"
  end

  it "registers the request correctly" do
    visit root_path
    expect { register_request_with("trick1", 200, request_header, request_body) }.to change(Request, :count).by(1)
    expect(page).to have_content "The Set Requests"
    expect(page).to have_content "trick1"
    expect(page).to have_content "200"
    expect(page).to have_content "abc"
    expect(page).to have_content "def"
    expect(page).to have_selector(".alert-success")
  end

  it "does not display any request When the page is first opened" do
    visit root_path
    expect(page).to_not have_content "The set requests"
  end

  context "as a guest user" do
    it "does not register requests no more than 6 requests" do
      visit root_path
      5.times { |n| register_request_with("trick#{n}", 200, request_header, request_body) }
      expect { register_request_with("trick", 200, request_header, request_body) }.to_not change(Request, :count)
      expect(page).to have_selector(".alert-danger")
    end
  end
end
