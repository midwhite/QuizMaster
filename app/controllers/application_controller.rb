class ApplicationController < ActionController::API
  before_action :set_locale

  def check
    render json: { message: "Success." }
  end

  private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end
end
