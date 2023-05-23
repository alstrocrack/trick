class UsersController < ApplicationController
  def index
    parameters = params.permit(:id)
    @user_account = UserAccount.find_by(id: parameters[:id])
    @api_key = ApiKey.find_by(owner_id: ApiKey.get_user_api_key(@user_account.id))
  end
end
