require "securerandom"

class LoginController < ApplicationController
  before_action :fetch_user_session, only: :logout
  def index
  end

  def authenticate
    execute("/login", "login", :email, :password) do |parameters|
      raise ApplicationError.new(ErrorCode::E1004, ErrorMessage::LackOfParameters) if parameters[:email].blank? || parameters[:password].blank?
      set_user_with_login(parameters[:email], parameters[:password])
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
