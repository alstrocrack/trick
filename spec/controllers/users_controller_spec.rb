require "rails_helper"

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user_account) }

  context "as an logined user" do
    let!(:user_session) { create(:user_session, user_id: user.id) }
    before do
      session[:user_id] = user.id
      session[:user_token] = "exmaple-session-value"
    end

    it "responds successfully" do
      get :show, params: { id: user.id }
      expect(response).to have_http_status "200"
    end
  end

  context "as an guest user" do
    it "redirects to the home page" do
      get :show, params: { id: user.id }
      expect(response).to have_http_status "302"
    end
  end

  context "as an other user" do
    let(:other_user) { create(:user_account, name: "other_user") }
    let!(:other_user_session) { create(:user_session, user_id: other_user.id, session_digest: BCrypt::Password.create("other-session-value")) }
    before do
      session[:user_id] = other_user.id
      session[:user_token] = "other-session-value"
    end

    it "redirects to the home page" do
      get :show, params: { id: user.id }
      expect(response).to have_http_status "302"
    end
  end
end
