require "json"
require "securerandom"

class HomeController < ApplicationController
  before_action :fetch_user_session

  def index
    @requests = Request.where(user_id: @user_account.id).order(id: :desc).limit(5) if @user_account
  end

  def add
    post_execute("/", "home", :status, :from, :header, :body) do |parameters|
      ActiveRecord::Base.transaction do
        raise ApplicationError.new(ErrorCode::E1002, ErrorMessage::From) if parameters[:from].blank?
        raise ApplicationError.new(ErrorCode::E1003, ErrorMessage::LimitRequetsExceeds) if @user_account && @user_account.is_exceed?
        header = parameters[:header].blank? ? nil : JSON.parse(parameters[:header])
        body = parameters[:body].blank? ? nil : JSON.parse(parameters[:body])
        request = Request.new(status_code: parameters[:status].to_i, from_address: parameters[:from], response_header: header, response_body: body)
        if @user_account
          request.user_id = @user_account
        elsif @guest_user
          request.guest_session_id = @guest_user
        else
          session[:guest] = SecureRandom.uuid
          guest_session = UserSession.new(value: session[:guest], status: UserSessionStatus::Temporary)
          guest_session.save!
          request.guest_session_id = guest_session.id
        end
        flash[:success] = "Successfully registerd" if request.save!
        redirect_to "/"
      end
    end
  end
end
