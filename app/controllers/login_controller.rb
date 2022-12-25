class LoginController < ApplicationController
  def index
  end

  def authenticate
    execute("/login", "login", email, password) do |parameters|
      if parameters[:email].blank? || parameters[:password].blank?
        raise ApplicationError.new(ErrorCode::E1004, ErrorMessage::LackOfParameters)
      end
    end
  end
end
