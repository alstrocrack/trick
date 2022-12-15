class ApplicationController < ActionController::Base
  before_action { @user = UserAccount.first }
end
