class ApplicationController < ActionController::Base
  before_action { @user = UserAccount.first }

  def execute(redirect, group, *filters)
    parameters = params.require(group).permit(filters)
    yield(parameters)
  rescue ApplicationError => e
    flash[:danger] = "E#{e.code}: #{e.msg}"
  rescue JSON::ParserError => e
    flash[:danger] = e
  ensure
    redirect_to redirect if redirect
  end
end
