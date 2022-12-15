require "json"

class HomeController < ApplicationController
  def index
    @requests = Request.where(user_id: @user.id)
  end

  def add
    if Request.valid?(params)
      request =
        Request.new(
          user_id: @user.id,
          from_address: params[:from],
          response_header: params[:header].to_json,
          response_body: params[:body].to_json
        )
      request.save!
      redirect_to "/"
    end
  end
end
