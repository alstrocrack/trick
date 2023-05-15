class UsersController < ApplicationController
  def index
    parameters = params.permit(:id)
    @user = UserAccount.find_by(id: parameters[:id])
  end
end
