class ApplicationController < ActionController::Base
  before_action { authenticate_user }

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
    user_account = UserAccout.find_by(email: email)
    raise ApplicationError.new(ErrorCode::E1005, ErrorMessage::NonExistentUsers) if user_account.nil?
    raise ApplicationError.new(ErrorCode::E1006, ErrorMessage::InvalidPassword) unless user_account.authenticate?(password)

    session[:user] = SecureRandom.uuid
    user_session = UserSession.new(value: session[:user], status: UserSessionStatus::Enable, user_id: user_account.id)
    user_session.save!
    @user_account = user_account
  end

  def authenticate_user
    # do process
  end
end
