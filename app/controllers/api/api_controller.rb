require "json"

module Api
  class ApiController < ApplicationController
    def get
      user, request_name = filter_paramter(:user, :request_name)
      if user =~ /\d+/
        request = Request.find_by(guest_id: user, name: request_name)
      else
        print("here")
        request =
          Request
            .joins("JOIN user_accounts ON requests.user_id = user_accounts.id")
            .where("user_accounts.name = ? AND requests.name = ?", user, request_name)
            .select("requests.status_code AS status, requests.response_header AS header, requests.response_body AS body")
            .first
      end
      response.headers.merge!("X-X-X" => "ok", "X-trick-status" => "ok")
      render json: request.body, status: request.status.to_i
    end

    def post
      render plain: "posted!"
    end

    private

    def filter_paramter(*args)
      parameters = params.permit(args)
      return parameters[:user], parameters[:request_name]
    end
  end
end
