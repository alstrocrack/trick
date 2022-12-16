require "json"

class HomeController < ApplicationController
  def index
    @requests = Request.where(user_id: @user.id)
  end

  def add
    raise ApplicationError.new(ErrorCode::E1002, ErrorMessage::From) if input[:from].blank?
    request =
      Request.new(
        user_id: @user.id,
        from_address: params[:from],
        response_header: JSON.parse(params[:header]),
        response_body: JSON.parse(params[:body])
      )
    request.save!
    redirect_to "/"
  end
end
