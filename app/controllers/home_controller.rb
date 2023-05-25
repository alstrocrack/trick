require "securerandom"

class HomeController < ApplicationController
  def index
    @api_key = nil
    if @user_account
      @requests = Request.where(user_id: @user_account.id).order(id: :desc)
      @api_key = @user_account.get_api_key
    elsif @guest_account
      @requests = Request.where(guest_id: @guest_account.id).order(id: :desc)
      @api_key = @guest_account.get_api_key
    end
  end

  def create
    post_execute("/", "home", :name, :key1, :key2, :key3, :val1, :val2, :val3, :status, :body) do |parameters|
      debugger
      ActiveRecord::Base.transaction do
        raise ApplicationError.new(ErrorCode::E1003, ErrorMessage::LimitRequetsExceeds) if (@user_account && @user_account.is_exceed?) || (@guest_account && @guest_account.is_exceed?)
        formatted_header = Request.format_header(parameters[:key1], parameters[:key2], parameters[:key3], parameters[:val1], parameters[:val2], parameters[:val3])
        request = Request.new(status_code: parameters[:status], name: parameters[:name], response_header: formatted_header, response_body: parameters[:body])
        request.validate_request
        if @user_account
          request.user_id = @user_account.id
        elsif @guest_account
          request.guest_id = @guest_account.id
        else
          session[:guest] = SecureRandom.uuid
          guest_session = UserSession.new(value: session[:guest], status: UserSessionStatus::Temporary)
          guest_session.save!
          ApiKey.create!(value: ApiKey.issue, owner_id: ApiKey.get_guest_api_key(guest_session.id))
          request.guest_id = guest_session.id
        end
        request.save!
        flash[:success] = "Successfully registerd"
        redirect_to "/"
      end
    end
  end

  def destroy
    destroy_execute("/", :id) do |parameters|
      request = nil
      if @user_account
        request = Request.find_by(id: params[:id], user_id: @user_account.id)
      elsif @guest_account
        request = Request.find_by(id: params[:id], guest_id: @guest_account.id)
      end
      raise ApplicationError.new(ErrorCode::E1010, ErrorMessage::NotFoundRequest) if request.nil?
      request.destroy!
      flash[:success] = "Successfully deleted!"
      redirect_to "/"
    end
  end
end
