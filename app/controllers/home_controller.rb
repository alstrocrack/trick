require "json"
require "securerandom"

class HomeController < ApplicationController
  def index
    if @user_account
      @requests = Request.where(user_id: @user_account.id).order(id: :desc)
    elsif @guest_user_id
      @requests = Request.where(guest_session_id: @guest_user_id).order(id: :desc)
    end
  end

  def add
    post_execute("/", "home", :name, :status, :header, :body) do |parameters|
      ActiveRecord::Base.transaction do
        raise ApplicationError.new(ErrorCode::E1003, ErrorMessage::LimitRequetsExceeds) if (@user_account && @user_account.is_exceed?) || (@guest_user_id && GuestUser.is_exceed?(@guest_user_id))
        raise ApplicationError.new(ErrorCode::E1009, ErrorMessage::InvalidRequestName) unless parameters[:name].present?
        header = parameters[:header].blank? ? nil : JSON.parse(parameters[:header])
        body = parameters[:body].blank? ? nil : JSON.parse(parameters[:body])
        request = Request.new(status_code: parameters[:status].to_i, name: parameters[:name], response_header: header, response_body: body)
        if @user_account
          request.user_id = @user_account.id
        elsif @guest_user_id
          request.guest_session_id = @guest_user_id
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

  def delete
    request = @user_account ? Request.find_by(id: params[:id], user_id: @user_account.id) : Request.find_by(id: params[:id], guest_session_id: @guest_user_id)
    request.destroy if request
    flash[:success] = "Successfully deleted!"
    redirect_to "/"
  end
end
