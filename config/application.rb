require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module QuizMaster
  class Application < Rails::Application
    config.load_defaults 5.2

    config.i18n.default_locale = :en
    config.time_zone = "UTC"
    config.active_record.default_timezone = :utc

    config.api_only = true

    config.generators do |g|
      g.test_framework :rspec,
        fixtures: true, controller_specs: false, request_specs: true
      g.fixture_replacement :factory_bot, dir: "spec/factories"
    end
  end
end
