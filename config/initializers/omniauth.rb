#OmniAuth.config.full_host = 'http://localhost:9999'

  Rails.application.config.middleware.use OmniAuth::Builder do
    provider :facebook, CONFIG['FACEBOOK_KEY'], CONFIG['FACEBOOK_SECRET'], {:client_options => { :ssl => { :ca_file => "#{Rails.root}/config/ca-bundle.crt" }}, :scope => 'publish_stream,offline_access,email'}
    provider :twitter, CONFIG['TWITTER_KEY'], CONFIG['TWITTER_SECRET'], :client_options => { :ssl => { :ca_file => "#{Rails.root}/config/ca-bundle.crt" }}
    provider :google_oauth2, CONFIG['GOOGLE_KEY'], CONFIG['GOOGLE_SECRET'], {:client_options => { :ssl => { :ca_file => "#{Rails.root}/config/ca-bundle.crt" }}, :scope => 'https://www.googleapis.com/auth/plus.me'}
  end
   # Sign-up urls for Facebook, Twitter, and Google
   # https://developers.facebook.com/setup
   # https://developer.twitter.com/apps/new
   # https://code.google.com/apis/console
