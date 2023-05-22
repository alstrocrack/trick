require "json"

module Api
  class ApiController < ApplicationController
    TRICK_HEADER_KEY = "X-trick-status"
    TRICK_HEADER_VALUE_OK = "OK"
    TRICK_HEADER_VALUE_NG = "NG"
    TRICK_API_KEY = "X-trick-apiKey"

    def get
      return_bad_request and return if request.headers[TRICK_API_KEY].nil?
      user, request_name = filter_paramter(:user, :request_name)
      request_to_return = nil
      if user =~ /\d+/
        return_bad_request and return if request.headers[TRICK_API_KEY] != GuestUser.get_api_key(user) # Compare Api Keys
        request_to_return = Request.find_by(guest_id: user, name: request_name)
      else
        return_bad_request and return if request.headers[TRICK_API_KEY] != UserAccount.get_api_key(user) # Compare Api Keys
        request_to_return =
          Request
            .joins("JOIN user_accounts ON requests.user_id = user_accounts.id")
            .where("user_accounts.name = ? AND requests.name = ?", user, request_name)
            .select("requests.status_code AS status, requests.response_header AS response_header, requests.response_body AS response_body")
            .first
      end
      return_bad_request and return if request_to_return.nil?
      request_to_return.return_header.each { |pair| response.headers[pair[:key]] = pair[:value] }
      response.headers[TRICK_HEADER_KEY] = TRICK_HEADER_VALUE_OK
      render json: request_to_return.response_body, status: request_to_return.status_code.blank? ? 200 : request_to_return.status_code.to_i
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
