class ApplicationController < ActionController::Base
  before_action { @user = UserAccount.first }
  skip_before_action :verify_authenticity_token

  def execute(redirect = "/", *filters)
    parameters = params.permit(filters)
    yield(parameters)
  rescue ApplicationError => e
    flash[:danger] = "E#{e.code}: #{e.msg}"
  rescue JSON::ParserError => e
    flash[:danger] = e
  ensure
    redirect_to redirect
  end
end
