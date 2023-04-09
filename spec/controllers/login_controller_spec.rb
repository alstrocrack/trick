require "rails_helper"

RSpec.describe LoginController, type: :controller do
  let(:user_account) { FactoryBot.create(:user_account) }
  let(:user_session) { FactoryBot.create(:user_session, user_id: user_account.id) }

  context "as an guest user" do
    it "responds successfully" do
      get :index
      expect(response).to have_http_status "200"
    end

    it "responds redirect when we send request to /authenticate" do
      post :authenticate, params: { email: "example@example.com", password: "example" }
      expect(response).to have_http_status "302"
    end
  end

  context "as an logined user" do
    before { session[:user] = user_session.value }

    it "responds redirect when we visit /login page" do
      get :index
      expect(response).to have_http_status "302"
    end

    it "responds redirect when we send request to /authenticate" do
      post :authenticate, params: { email: "example@example.com", password: "example" }
      expect(response).to have_http_status "302"
    end
  end
end
