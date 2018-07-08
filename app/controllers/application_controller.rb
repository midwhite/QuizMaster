class ApplicationController < ActionController::API
  before_action :set_locale

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
end
