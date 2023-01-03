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

  def authenticate_user
    user_session = UserSession.find_by(value: session[:user], status: UserSessionStatus::Enable)
    raise ApplicationError.new(ErrorCode::E1007, ErrorMessage::InvalidUserSession) if user_session.nil?
    user_account = UserAccount.find_by(id: user_session.user_id)
    raise ApplicationError.new(ErrorCode::E1007, ErrorMessage::InvalidUserSession) if user_account.nil?
    if user_session.expired_at.nil?
      @user_account = user_account
    else
      if Time.now >= user_session.expired_at
        logout
        redirect_to "/"
      else
        @user_account = user_account
      end
    end
  end

  def logout
    user_session = UserSession.find_by(value: session[:user], status: UserSessionStatus::Enable, user_id: @user_account.id)
    user_session.status = UserSessionStatus::Disable
    user_session.save!
    @user_account, session[:user] = nil
    redirect_to "/"
  end
end
