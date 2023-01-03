require "securerandom"

class LoginController < ApplicationController
  def index
  end

  def authenticate
    execute("/login", "login", :email, :password) do |parameters|
      raise ApplicationError.new(ErrorCode::E1004, ErrorMessage::LackOfParameters) if parameters[:email].blank? || parameters[:password].blank?
      set_user_with_login(parameters[:email], parameters[:password])
    end
  end
end
