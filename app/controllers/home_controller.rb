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
        request =
          Request.new(
            status_code: parameters[:status].to_i,
            name: parameters[:name],
            response_header: parameters[:header].present? ? parameters[:header] : nil,
            response_body: parameters[:body].present? ? parameters[:body] : nil
          )
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
    delete_execute("/", :id) do |parameters|
      request = nil
      if @user_account
        request = Request.find_by(id: params[:id], user_id: @user_account.id)
      elsif @guest_user_id
        request = Request.find_by(id: params[:id], guest_session_id: @guest_user_id)
      end
      raise ApplicationError.new(ErrorCode::E1010, ErrorMessage::NotFoundRequest) if request.nil?
      request.destroy!
      flash[:success] = "Successfully deleted!"
      redirect_to "/"
    end
  end
end
