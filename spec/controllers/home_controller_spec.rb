require "rails_helper"

RSpec.describe HomeController, type: :controller do
  describe "#index" do
    it "responds successfully" do
      get :index
      expect(response).to have_http_status "200"
    end
  end

  describe "#add" do
    it "responds successfully" do
      post :create, params: { name: "trick", key1: "X-api-key", value1: "abcdef", status: 200, response_body: { text: "text" } }
      expect(response).to have_http_status "302"
    end
  end

  describe "#delete" do
    before { Request.create!(id: 1, name: "trick", response_header: { "X-api-key": "abcdef" }, status_code: 200, response_body: { text: "text" }) }
    it "responds successfully" do
      delete :destroy, params: { id: 1 }
      expect(response).to have_http_status "302"
    end
  end
end
