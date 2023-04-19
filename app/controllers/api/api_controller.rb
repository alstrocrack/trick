require "json"

module Api
  class ApiController < ApplicationController
    TRICK_HEADER_KEY = "X-trick-status"
    TRICK_HEADER_VALUE_OK = "OK"
    TRICK_HEADER_VALUE_NG = "NG"

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
      if request.nil? # I'd like to return early, but Rails also does the processing after "render" and "head", so I have to branch conditionally.
        return_bad_request
      else
        request.return_header.each { |pair| response.headers[pair[:key]] = pair[:value] }
        response.headers[TRICK_HEADER_KEY] = TRICK_HEADER_VALUE_OK
        render json: request.response_body, status: request.status.blank? ? :ok : request.status.to_i
      end
    end

    def ng_request
      return_bad_request
    end

    private

    def filter_paramter(*args)
      parameters = params.permit(args)
      return parameters[:user], parameters[:request_name]
    end

    def return_bad_request
      response.headers[TRICK_HEADER_KEY] = TRICK_HEADER_VALUE_NG
      head 400
    end
  end
end
