class HomeController < ApplicationController
  def index
    @user = User.first
  end

  def add_new_request
    raise ApplicationError.new(ErrorCode::E1000, ErrorMessage::Param) if params[:from].blank?
    # puts "Hello"
    redirect_to "/"
  end
end
