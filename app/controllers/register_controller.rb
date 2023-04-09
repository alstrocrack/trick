require "digest"

class RegisterController < ApplicationController
  before_action :validate_register_page

  def index
  end

  def register
    post_execute("/register", "register", :name, :email, :password) do |parameters|
      raise ApplicationError.new(ErrorCode::E1002, ErrorMessage::Email) if UserAccount.find_by(email: parameters[:email])
      raise ApplicationError.new(ErrorCode::E1008, ErrorMessage::UserName) if UserAccount.find_by(name: parameters[:name])
      new_user_account = UserAccount.new(name: parameters[:name], email: parameters[:email], password_hash: Digest::SHA256.hexdigest(parameters[:password].strip))
      if new_user_account.save!
        @user_account = new_user_account
        session[:user] = SecureRandom.uuid
        user_session = UserSession.new(value: session[:user], status: UserSessionStatus::Enable, user_id: @user_account.id)
        session[:guest] = nil if user_session.save! && session[:guest]
        flash[:success] = "Successfully registerd!"
      end
      redirect_to "/"
    end
  end

  private

  def validate_register_page
    redirect_to "/" if @user_account
  end
end
