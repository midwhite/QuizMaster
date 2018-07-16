class ApplicationController < ActionController::API
  rescue_from ActionController::RoutingError, with: :render_404 if Rails.env.production?
  rescue_from ActiveRecord::RecordNotFound, with: :render_404   if Rails.env.production?
  rescue_from Exception, with: :render_500                      if Rails.env.production?

  before_action :set_locale
  before_action :sign_in_user, except: [:check]

  def check
    render json: { message: t(".success") }
  end

  def render_404
    render status: :not_found, json: { errors: [t("application_controller.render_404.not_found")] }
  end

  def render_500
    # [TODO] notify error to admin
    render status: 500, json: { errors: [t("application_controller.render_500.unexpected_error")] }
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
    render status: :unauthorized, json: { errors: [t("devise.failure.unauthenticated")] }
  end
end
