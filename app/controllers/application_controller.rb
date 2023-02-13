class ApplicationController < ActionController::Base
  # Provide strong parameter mechanism and exception handling when executing POST method
  # @param [String] fail_redirect_path Redirects to when processing fails
  # @param [String] group Specify a group of POST parameters
  # @param [Array] *filters Specify which of the POST parameters are permitted
  # @note The redirect destination on successful processing is specified in the caller of the "post_execute" method
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
    if session[:user]
      user_session = UserSession.find_by(value: session[:user], status: UserSessionStatus::Enable)
      @user_account = UserAccount.find_by(id: user_session.user_id) if user_session
    elsif session[:guest]
      @guest_user_id = UserSession.find_by(value: session[:guest], status: UserSessionStatus::Temporary).id
    end
  end
end
