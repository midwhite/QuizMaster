module Constants
  INFO_MAIL_ADDRESS = "info@quiz-master.com"

  APP_DOMAIN = Rails.env.development? ? "http://localhost:8080" : "https://quiz-master.com"

  DEFAULT_TIMEZONE = "UTC"
  RESPONSE_DATE_FORMAT = "%Y-%m-%d"
  RESPONSE_DATETIME_FORMAT = "%Y-%m-%d %H:%M:%S"
end