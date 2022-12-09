class HomeController < ApplicationController
  def index
    @user = User.first
  end

  def add_new_request
    if params[:from].blank?
      raise ApplicationError.new(ErrorCode::E1000, ErrorMessage::Param)
    end
    # puts "Hello"
    redirect_to "/"
  end
end
