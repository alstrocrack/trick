require "digest"

class RegisterController < ApplicationController
  before_action :validate_register_page

  def index
  end

  def create
    ActiveRecord::Base.transaction do
      post_execute("/register", "register", :name, :email, :password) do |parameters|
        if parameters[:name].blank? || parameters[:email].blank? || parameters[:password].blank?
          raise ApplicationError.new(ErrorCode::E1011, ErrorMessage::LackOfParametersWithName)
        end
        raise ApplicationError.new(ErrorCode::E1002, ErrorMessage::Email) if UserAccount.find_by(email: parameters[:email])
        raise ApplicationError.new(ErrorCode::E1008, ErrorMessage::UserName) if UserAccount.find_by(name: parameters[:name])
        new_user_account = UserAccount.new(name: parameters[:name], email: parameters[:email], password_hash: Digest::SHA256.hexdigest(parameters[:password].strip))
        new_user_account.save!
        ApiKey.create!(value: ApiKey.issue, owner_id: ApiKey.get_user_api_key(new_user_account.id))
        Request.where(guest_id: @guest_account.id).update_all(user_id: new_user_account.id, guest_id: nil, updated_at: Time.now) if @guest_account
        set_authenticated_user(new_user_account)
        SendAuthMailJob.perform_later(new_user_account.email, new_user_account.name)
        flash[:success] = "Successfully registerd!"
        redirect_to "/"
      end
    end
  end

  private

  def validate_register_page
    redirect_to "/" if @user_account
  end
end
