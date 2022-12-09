class HomeController < ApplicationController
  def index
    @user = UserAccount.first
  end

  def add_new_request
    raise ApplicationError.new(ErrorCode::E1000, ErrorMessage::Param) if params[:from].blank?
    request =
      Request.new(
        from_address: params[:from],
        response_header: params[:header],
        response_body: params[:body],
      )
    request.save!
    redirect_to "/"
  end
end
