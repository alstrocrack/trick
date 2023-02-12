require "json"

class HomeController < ApplicationController
  before_action :fetch_user_session

  def index
    @requests = Request.where(user_id: @user_account.id).order(id: :desc).limit(5) if @user_account
  end

  def add
    post_execute("/", "home", :user_id, :from, :header, :body) do |parameters|
      raise ApplicationError.new(ErrorCode::E1002, ErrorMessage::From) if parameters[:from].blank?
      raise ApplicationError.new(ErrorCode::E1003, ErrorMessage::LimitRequetsExceeds) if @user_account && @user_account.is_exceed?
      header = parameters[:header].blank? ? nil : JSON.parse(parameters[:header])
      body = parameters[:body].blank? ? nil : JSON.parse(parameters[:body])
      request = Request.new(user_id: @user_account&.id, from_address: parameters[:from], response_header: header, response_body: body)
      flash[:success] = "Successfully registerd" if request.save!
      redirect_to "/"
    end
  end
end
