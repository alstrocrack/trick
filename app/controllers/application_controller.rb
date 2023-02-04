class ApplicationController < ActionController::Base
  def post_execute(fail_redirect_path, group, *filters)
    parameters = params.require(group).permit(filters)
    yield(parameters)
  rescue ApplicationError => e
    flash[:danger] = "E#{e.code}: #{e.msg}"
    redirect_to if fail_redirect_path
  rescue JSON::ParserError => e
    flash[:danger] = e
    redirect_to if fail_redirect_path
  rescue => e
    flash[:danger] = e
    redirect_to if fail_redirect_path
  end

  def fetch_user_session
    user_session = UserSession.find_by(value: session[:user], status: UserSessionStatus::Enable)
    @user_account = nil
    @user_account = UserAccount.find_by(id: user_session.user_id) if user_session
  end
end
