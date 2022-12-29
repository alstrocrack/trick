require "digest"

class LoginController < ApplicationController
  def index
  end

  def authenticate
    execute("/login", "login", email, password) do |parameters|
      raise ApplicationError.new(ErrorCode::E1004, ErrorMessage::LackOfParameters) if parameters[:email].blank? || parameters[:password].blank?
      user_account = UserAccout.find_by(email: parameters[:email])
      raise ApplicationError.new(ErrorCode::E1005, ErrorMessage::NonExistentUsers) if user_account.nil?
      password_hash = Digest::SHA256.digest(parameters[:password].strip)
      raise ApplicationError.new(ErrorCode::E1006, ErrorMessage::InvalidPassword) unless user_account.authenticate?(password_hash)
      # make session.
    end
  end
end
