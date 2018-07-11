class V1::UsersController < ApplicationController
  skip_before_action :sign_in_user, only: [:sign_up, :login]

  def sign_up
    user = User.new(registerable_params)
    if user.save
      render status: :created, json: { user: user.me }
    else
      render status: :bad_request, json: { errors: user.errors.full_messages }
    end
  end

  def login
  end

  def me
    render json: { user: user.me }
  end

  private
  def registerable_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
