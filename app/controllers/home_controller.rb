class HomeController < ApplicationController
  def index
    @user = User.first
  end

  def add_new_request
    raise "NULL From" if params[:from].blank?
    # puts "Hello"
    redirect_to "/"
  end
end
