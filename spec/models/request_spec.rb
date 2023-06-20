require "rails_helper"

RSpec.describe Request, type: :model do
  let(:request) { create(:request) }
  describe "#validate_request" do
    context "when valid request" do
      it "doesn't raise ApplicationError" do
        expect { request.validate_request }.to_not raise_error
      end
    end

    context "when invalid status_code" do
      let(:request) { create(:request, status_code: "invalid_status_code") }
      it "raises Application Error" do
        expect { request.validate_request }.to raise_error(ApplicationError)
      end
    end

    context "when blank name" do
      let(:request) { create(:request, name: nil) }
      it "raises Application Error" do
        expect { request.validate_request }.to raise_error(ApplicationError)
      end
    end
  end
end
