class ApplicationController < ActionController::Base
  before_action { @user = UserAccount.first }

  rescue_with ApplicationError, with: ->(e) {}
end
