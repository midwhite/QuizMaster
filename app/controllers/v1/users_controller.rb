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
    user = User.find_by(email: params[:user] && params[:user][:email])

    if user.blank?
      # in case email is not registered
      render status: :not_found, json: { errors: [t(".email_not_found")] } and return
    elsif !user.valid_password?(params[:user] && params[:user][:password])
      # in case password is wrong
      render status: :bad_request, json: { errors: [t(".wrong_password")] } and return
    end
    # in case user succeeds in signing in
    render json: { user: user.me }
  end

  def me
    render json: { user: user.me }
  end

  private
  def registerable_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
