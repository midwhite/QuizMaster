class ApplicationController < ActionController::API
  before_action :set_locale
  before_action :sign_in_user, except: [:check]

  def check
    render json: { message: t(".success") }
  end

  private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end

  def t(key, **option)
    if key[0] === '.'
      key = controller_name + "_controller." + action_name + key
    end
    I18n.t(key, **option)
  end

  def sign_in_user
    auth_token = request.headers["Authorization"]

    if auth_token && auth_token.include?(":")
      authenticate_with_auth_token auth_token
    else
      authenticate_error
    end
  end

  def authenticate_with_auth_token(auth_token)
    user = User.find_by(id: auth_token.split(':').first)

    if user && Devise.secure_compare(user.access_token, auth_token)
      sign_in user, store: false
    else
      authenticate_error
    end
  end

  def authenticate_error
    render status: :unauthorized, json: { error: t("devise.failure.unauthenticated") }
  end
end
