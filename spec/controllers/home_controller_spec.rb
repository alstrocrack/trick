require "rails_helper"

RSpec.describe HomeController, type: :controller do
  let(:request_params) do
    {
      name: "trick",
      status: 200,
      key1: "x-abc-key",
      key2: "x-def-key",
      key3: "x-ghi-key",
      value1: "abc",
      value2: "def",
      value: "ghi",
      response_body: {
        text: "text"
      }
    }
  end

  let(:invalid_request_params) do
    {
      name: nil,
      status: 200,
      key1: "x-abc-key",
      key2: "x-def-key",
      key3: "x-ghi-key",
      value1: "abc",
      value2: "def",
      value: "ghi",
      response_body: {
        text: "text"
      }
    }
  end
  let(:request) { create(:request) }

  describe "#index" do
    it "responds successfully" do
      get :index
      expect(response).to have_http_status "200"
    end
  end

  describe "#create" do
    context "when valid params" do
      it "redirects to the home page" do
        post :create, params: request_params
        expect(response).to have_http_status "302"
      end
    end

    context "when invalid params" do
      it "redirects to the home page" do
        post :create, params: request_params
        expect(response).to have_http_status "302"
      end
    end
  end

  describe "#destroy" do
    context "when valid request" do
      it "redirects to the home page" do
        delete :destroy, params: { id: request.id }
        expect(response).to have_http_status "302"
      end
    end

    context "when valid request" do
      it "redirects to the home page" do
        delete :destroy, params: { id: -1 }
        expect(response).to have_http_status "302"
      end
    end
  end
end
