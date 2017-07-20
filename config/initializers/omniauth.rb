require_dependency 'omniauth'
require_dependency 'omniauth-google-oauth2'

Rails.application.config.middleware.use OmniAuth::Builder do
  raise "No OAUTH_CLIENT_ID provided" unless ENV['OAUTH_CLIENT_ID']
  raise "No OAUTH_CLIENT_SECRET provided" unless ENV['OAUTH_CLIENT_SECRET']

  provider :google_oauth2,
    ENV['OAUTH_CLIENT_ID'],
    ENV['OAUTH_CLIENT_SECRET'],
    {
      name: "google_login",
      approval_prompt: '',
      verify_iss: false,      # Fix Google screwing around with ISS spec. See https://github.com/zquestz/omniauth-google-oauth2/issues/292
    }
end
