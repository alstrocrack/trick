class LoginController < ApplicationController
  before_action :validate_login_page, only: %i[index authenticate]

  def index
  end

  def authenticate
    post_execute("/login", "login", :email, :password) do |parameters|
      raise ApplicationError.new(ErrorCode::E1004, ErrorMessage::LackOfParameters) if parameters[:email].blank? || parameters[:password].blank?
      user_account = UserAccount.find_by(email: parameters[:email])
      raise ApplicationError.new(ErrorCode::E1005, ErrorMessage::NonExistentUsers) if user_account.nil?
      raise ApplicationError.new(ErrorCode::E1006, ErrorMessage::InvalidPassword) unless user_account.authenticate?(parameters[:password])
      set_authenticated_user(user_account)
      flash[:success] = "Successfully login!"
      redirect_to "/"
    end
  end

  def logout
    delete_execute("/") do
      raise ApplicationError.new(ErrorCode::E1012, ErrorMessage::NotLoggedIn) unless @user_account
      user_session = UserSession.find_by(value: session[:user], status: UserSessionStatus::Enable, user_id: @user_account.id)
      user_session.status = UserSessionStatus::Disable
      user_session.save!
      @user_account, session[:user] = nil
      flash[:success] = "Successfully logout!"
      redirect_to "/"
    end
  end

  private

  def validate_login_page
    redirect_to "/" if @user_account
  end
end
