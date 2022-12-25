require "json"

class HomeController < ApplicationController
  def index
    @requests = Request.where(user_id: @user.id).order(id: :desc).limit(5)
  end

  def add
    execute("/", "home", :user_id, :from, :header, :body) do |parameters|
      raise ApplicationError.new(ErrorCode::E1002, ErrorMessage::From) if parameters[:from].blank?
      raise ApplicationError.new(ErrorCode::E1003, ErrorMessage::LimitRequetsExceeds) if @user.is_exceed?
      if request =
           Request.new(
             user_id: @user.id,
             from_address: parameters[:from],
             response_header: JSON.parse(parameters[:header]),
             response_body: JSON.parse(parameters[:body])
           )
      end
      request.save!
      flash[:success] = "Successfully registerd"
    end
  end
end
