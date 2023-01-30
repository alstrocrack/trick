class ApplicationController < ActionController::Base
  def execute(redirect, group, *filters)
    parameters = params.require(group).permit(filters)
    yield(parameters)
  rescue ApplicationError => e
    flash[:danger] = "E#{e.code}: #{e.msg}"
  rescue JSON::ParserError => e
    flash[:danger] = e
  rescue => e
    flash[:danger] = e
  ensure
    redirect_to redirect if redirect
  end

  def set_user_with_login(email, password)
    user_account = UserAccount.find_by(email: email)
    raise ApplicationError.new(ErrorCode::E1005, ErrorMessage::NonExistentUsers) if user_account.nil?
    raise ApplicationError.new(ErrorCode::E1006, ErrorMessage::InvalidPassword) unless user_account.authenticate?(password)

    session[:user] = SecureRandom.uuid
    user_session = UserSession.new(value: session[:user], status: UserSessionStatus::Enable, user_id: user_account.id)
    user_session.save!
  end

  def fetch_user_session
    user_session = UserSession.find_by(value: session[:user], status: UserSessionStatus::Enable)
    @user_account = nil
    @user_account = UserAccount.find_by(id: user_session.user_id) if user_session
  end
end
