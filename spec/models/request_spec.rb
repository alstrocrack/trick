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

  describe "#validate_user_request" do
    let(:user) { create(:user_account) }
    let(:request) { create(:request, user_id: user.id) }
    let(:request_exec) { request.validate_user_request(user) }

    xcontext "when valid request" do
      let(:request) { create(:request, user_id: user.id) }
      it "doesn't raise ApplicationError" do
        expect { request.reload.validate_user_request(user) }.to_not raise_error
      end
    end

    context "when duplicate request exists" do
      let!(:duplicate_request) { create(:request, user_id: user.id, name: "dup-request") }
      let(:request) { create(:request, user_id: user.id, name: "dup-request") }

      it "raises Application Error" do
        expect { request_exec }.to raise_error(ApplicationError)
      end
    end

    context "when 5 or more requests" do
      let!(:multiple_request) { create_list(:request, 5, user_id: user.id) }
      it "raises Application Error" do
        expect { request_exec }.to raise_error(ApplicationError)
      end
    end
  end
end
