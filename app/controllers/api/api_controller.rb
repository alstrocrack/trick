require "json"

module Api
  class ApiController < ApplicationController
    def get
      user, request_name = filter_paramter(:user, :request_name)
      request = nil
      if user =~ /\d+/
        request = Request.find_by(guest_id: user, name: request_name)
      else
        request =
          Request
            .joins("JOIN user_accounts ON requests.user_id = user_accounts.id")
            .where("user_accounts.name = ? AND requests.name = ?", user, request_name)
            .select("requests.status_code AS status, requests.response_header AS response_header, requests.response_body AS response_body")
            .first
      end
      request.return_header.each { |pair| response.headers[pair[:key]] = pair[:value] }
      response.headers["X-trick-status"] = "ok"
      render json: request.response_body, status: request.status.blank? ? :ok : request.status.to_i
    end

    private

    def filter_paramter(*args)
      parameters = params.permit(args)
      return parameters[:user], parameters[:request_name]
    end
  end
end
