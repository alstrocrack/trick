class UsersController < ApplicationController
  before_action :validate_user_page

  def show
    @api_key = ApiKey.find_by(owner_id: ApiKey.get_user_api_key(@user_account.id))
  end

  private

  def validate_user_page
    redirect_to "/" if @user_account.nil? || params[:id].to_i != @user_account.id
  end
end
