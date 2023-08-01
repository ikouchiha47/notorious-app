Recaptcha.configure do |config|
  creds = Rails.application.credentials
  config.site_key = creds.recaptcha_site_key
  config.secret_key = creds.recaptcha_secret_key
end
