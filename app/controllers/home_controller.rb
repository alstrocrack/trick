require "json"

class HomeController < ApplicationController
  def index
    @requests = Request.where(user_id: @user.id).order(id: :desc)
  end

  def add
    execute("/", :user_id, :from, :header, :body) do |parameters|
      raise ApplicationError.new(ErrorCode::E1002, ErrorMessage::From) if parameters[:from].blank?
      request =
        Request.new(
          user_id: @user.id,
          from_address: parameters[:from],
          response_header: parameters[:header],
          response_body: parameters[:body]
        )
      request.save!
    end
  end
end
