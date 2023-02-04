require "securerandom"

class LoginController < ApplicationController
  before_action :fetch_user_session, only: :logout
  def index
  end

  def authenticate
    post_execute("/login", "login", :email, :password) do |parameters|
      raise ApplicationError.new(ErrorCode::E1004, ErrorMessage::LackOfParameters) if parameters[:email].blank? || parameters[:password].blank?
      user_account = UserAccount.find_by(email: parameters[:email])
      raise ApplicationError.new(ErrorCode::E1005, ErrorMessage::NonExistentUsers) if user_account.nil?
      raise ApplicationError.new(ErrorCode::E1006, ErrorMessage::InvalidPassword) unless user_account.authenticate?(parameters[:password])
      session[:user] = SecureRandom.uuid
      user_session = UserSession.new(value: session[:user], status: UserSessionStatus::Enable, user_id: user_account.id)
      user_session.save!
      redirect_to "/"
    end
  end

  def logout
    user_session = UserSession.find_by(value: session[:user], status: UserSessionStatus::Enable, user_id: @user_account.id)
    user_session.status = UserSessionStatus::Disable
    user_session.save!
    @user_account, session[:user] = nil
    redirect_to "/"
  end
end
