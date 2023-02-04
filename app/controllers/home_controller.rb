require "json"

class HomeController < ApplicationController
  before_action :fetch_user_session

  def index
    @requests = Request.where(user_id: @user_account.id).order(id: :desc).limit(5) if @user_account
  end

  def add
    post_execute("/", "home", :user_id, :from, :header, :body) do |parameters|
      raise ApplicationError.new(ErrorCode::E1002, ErrorMessage::From) if parameters[:from].blank?
      raise ApplicationError.new(ErrorCode::E1003, ErrorMessage::LimitRequetsExceeds) if @user_account.is_exceed?
      request = Request.new(user_id: @user_account.id, from_address: parameters[:from], response_header: JSON.parse(parameters[:header]), response_body: JSON.parse(parameters[:body]))
      request.save!
      flash[:success] = "Successfully registerd"
    end
  end
end
