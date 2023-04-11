require "digest"

class RegisterController < ApplicationController
  before_action :validate_register_page

  def index
  end

  def register
    ActiveRecord::Base.transaction do
      post_execute("/register", "register", :name, :email, :password) do |parameters|
        raise ApplicationError.new(ErrorCode::E1011, ErrorMessage::LackOfParametersWithName) if parameters[:name].blank? || parameters[:email].blank? || parameters[:password].blank?
        raise ApplicationError.new(ErrorCode::E1002, ErrorMessage::Email) if UserAccount.find_by(email: parameters[:email])
        raise ApplicationError.new(ErrorCode::E1008, ErrorMessage::UserName) if UserAccount.find_by(name: parameters[:name])
        new_user_account = UserAccount.new(name: parameters[:name], email: parameters[:email], password_hash: Digest::SHA256.hexdigest(parameters[:password].strip))
        new_user_account.save!

        @user_account = new_user_account
        session[:user] = SecureRandom.uuid
        user_session = UserSession.new(value: session[:user], status: UserSessionStatus::Enable, user_id: @user_account.id)

        Request.where(guest_id: @guest_user_id).update_all(user_id: @user_account.id, guest_id: nil, updated_at: Time.now) if @guest_user_id
        session[:guest], @guest_user_id = nil if user_session.save! && session[:guest]
        flash[:success] = "Successfully registerd!"
        redirect_to "/"
      end
    end
  end

  private

  def validate_register_page
    redirect_to "/" if @user_account
  end
end
