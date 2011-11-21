#OmniAuth.config.full_host = 'http://localhost:9999'
Rails.application.config.middleware.use OmniAuth::Builder do
   # ALWAYS RESTART YOUR SERVER IF YOU MAKE CHANGES TO THESE SETTINGS!

   # you need a store for OpenID; (if you deploy on heroku you need Filesystem.new('./tmp') instead of Filesystem.new('/tmp'))
   #require 'openid/store/filesystem'
   ## load certificates
   #require "openid/fetchers"
   #OpenID.fetcher.ca_file = "#{Rails.root}/config/ca-bundle.crt"

   provider :facebook, FACEBOOK_KEY, FACEBOOK_SECRET, {:client_options => { :ssl => { :ca_file => "#{Rails.root}/config/ca-bundle.crt" }}, :scope => 'publish_stream,offline_access,email'}
   provider :twitter, 	TWITTER_KEY, TWITTER_SECRET, :client_options => { :ssl => { :ca_file => "#{Rails.root}/config/ca-bundle.crt" }}
   provider :google_oauth2, GOOGLE_KEY, GOOGLE_SECRET, {:client_options => { :ssl => { :ca_file => "#{Rails.root}/config/ca-bundle.crt" }}, :scope => 'https://www.googleapis.com/auth/plus.me'}

   # generic openid
   #provider :openid, :store => OpenID::Store::Filesystem.new('/tmp'), :name => 'openid'

   # dedicated openid
   #provider :openid, :store => OpenID::Store::Filesystem.new('/tmp'), :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'
   # provider :google_apps, OpenID::Store::Filesystem.new('./tmp'), :name => 'google_apps'
   # /auth/google_apps; you can bypass the prompt for the domain with /auth/google_apps?domain=somedomain.com

   #provider :openid, :store => OpenID::Store::Filesystem.new('/tmp'), :name => 'yahoo', :identifier => 'yahoo.com'
   #provider :openid, :store => OpenID::Store::Filesystem.new('/tmp'), :name => 'aol', :identifier => 'openid.aol.com'
   #provider :openid, :store => OpenID::Store::Filesystem.new('/tmp'), :name => 'myopenid', :identifier => 'myopenid.com'

   # Sign-up urls for Facebook, Twitter, and Github
   # https://developers.facebook.com/setup
   # https://github.com/account/applications/new
   # https://developer.twitter.com/apps/new
   # https://code.google.com/apis/console
end