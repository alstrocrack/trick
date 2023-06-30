require "rails_helper"

RSpec.describe RegisterController, type: :controller do
  let(:user) { create(:user_account) }
  let(:params) { { name: "example_user", email: "example@example.com", password: "example" } }

  context "as an guest user" do
    it "responds successfully" do
      get :index
      expect(response).to have_http_status "200"
    end

    it "responds redirect when we send request to /create" do
      post :create, params: params
      expect(response).to have_http_status "302"
    end
  end

  context "as an logined user" do
    let!(:user_session) { create(:user_session, user_id: user.id) }
    before do
      session[:user_id] = user.id
      session[:user_token] = "exmaple-session-value"
    end

    it "responds redirect when we visit /create page" do
      get :index
      expect(response).to have_http_status "302"
    end

    it "responds redirect when we send request to /create" do
      post :create, params: params
      expect(response).to have_http_status "302"
    end
  end
end
