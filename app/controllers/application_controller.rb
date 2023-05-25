require "securerandom"

class ApplicationController < ActionController::Base
  before_action :fetch_user_session

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
    redirect_to fail_redirect_path if fail_redirect_path
  rescue JSON::ParserError => e
    flash[:danger] = e
    redirect_to fail_redirect_path if fail_redirect_path
  rescue => e
    flash[:danger] = e
    redirect_to fail_redirect_path if fail_redirect_path
  end

  # Provide strong parameter mechanism and exception handling when executing DELETE method
  # @param [String] fail_redirect_path Redirects to when processing fails
  # @param [Array] *filters Specify which of the DELETE parameters are permitted
  # @note The redirect destination on successful processing is specified in the caller of the "destroy_execute" method
  def destroy_execute(fail_redirect_path, *filters)
    parameters = nil # If you don't write it like this, you will get an error that the filter is undefined
    parameters = params.permit(filters) if filters.size > 0
    yield(parameters)
  rescue ApplicationError => e
    flash[:danger] = "E#{e.code}: #{e.msg}"
    redirect_to fail_redirect_path if fail_redirect_path
  rescue => e
    flash[:danger] = e
    redirect_to fail_redirect_path if fail_redirect_path
  end

  # Discard everything related to guest_user when newly registered or logged in, and switch session to user_account
  # @param [ActiveRecord::Relation] Records properly retrieved from the UserAccounts table
  # @note Session management is also done by this method
  def set_authenticated_user(authenticated_user_account)
    @user_account = authenticated_user_account
    session[:user] = SecureRandom.uuid
    user_session = UserSession.new(value: session[:user], status: UserSessionStatus::Enable, user_id: @user_account.id)
    user_session.save!
    @guest_account, session[:guest] = nil if @guest_account || session[:guest] # Destroy session if session[:guest] exists
  end

  private

  def fetch_user_session
    if session[:user]
      user_session = UserSession.find_by(value: session[:user], status: UserSessionStatus::Enable)
      @user_account = UserAccount.find_by(id: user_session.user_id) if user_session
    elsif session[:guest]
      # Since we don't need to register a record in the user_accounts table, we only need to get the id from the user_sessions table.
      @guest_account = GuestUser.new(session[:guest])
    end
  end
end
