module Constants
  INFO_MAIL_ADDRESS = "info@quiz-master.com"

  APP_DOMAIN = Rails.env.development? ? "http://localhost:8080" : "https://quiz-master.com"
end