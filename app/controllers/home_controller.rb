require "json"

class HomeController < ApplicationController
  def index
    @requests = Request.where(user_id: @user.id)
  end

  def add
    begin
      params.permit(:user_id, :from, :header, :body)
      raise ApplicationError.new(ErrorCode::E1002, ErrorMessage::From) if params[:from].blank?
      request = Request.new(user_id: @user.id, from_address: params[:from], response_header: params[:header], response_body: params[:body])
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
