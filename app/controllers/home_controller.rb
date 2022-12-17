require "json"

class HomeController < ApplicationController
  def index
    @requests = Request.where(user_id: @user.id)
  end

  def add
    begin
      raise ApplicationError.new(ErrorCode::E1002, ErrorMessage::From) if params[:from].blank?
      request =
        Request.new(
          user_id: @user.id,
          from_address: params[:from],
          response_header: JSON.parse(params[:header]),
          response_body: JSON.parse(params[:body])
        )
      request.save!
    rescue ApplicationError => e
      flash[:danger] = "E#{e.code}: #{e.msg}"
    rescue JSON::ParserError => e
      flash[:danger] = e
    ensure
      redirect_to "/"
    end
  end
end
