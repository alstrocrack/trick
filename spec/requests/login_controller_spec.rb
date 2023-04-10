require "rails_helper"

RSpec.describe "LoginController", type: :request do
  let(:user_account) { FactoryBot.create(:user_account, email: "example@example.com") }
  let(:user_session) { FactoryBot.create(:user_session, user_id: user_account.id) }

  context "as an guest user" do
    it "calls autenticate method" do
      params = { email: "example@example.com", password: "example" }
      expect_any_instance_of(LoginController).to receive(:authenticate).once

      post login_path, params: params
    end
  end

  context "as an logined user" do
    # Session operation does not work, fix required
    before { allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(user: user_session.value) }

    it "doesn't call authenticate method" do
      params = { email: "example@example.com", password: "password" }
      expect_any_instance_of(LoginController).to_not receive(:authenticate)

      post login_path, params: params
    end
  end
end
