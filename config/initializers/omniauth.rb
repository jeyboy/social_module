#OmniAuth.config.full_host = 'http://127.0.0.1:9999'#'http://89.21.94.196:9999/'
Rails.application.config.middleware.use OmniAuth::Builder do
   # ALWAYS RESTART YOUR SERVER IF YOU MAKE CHANGES TO THESE SETTINGS!

   # you need a store for OpenID; (if you deploy on heroku you need Filesystem.new('./tmp') instead of Filesystem.new('/tmp'))
   require 'openid/store/filesystem'
   # load certificates
   require "openid/fetchers"
   OpenID.fetcher.ca_file = "#{Rails.root}/config/ca-bundle.crt"

   # providers with id/secret, you need to sign up for their services (see below) and enter the parameters here
   provider :facebook, '199230350153731', '848bf091c75cd9b561169fdbe8a04f8a', :client_options => { :ssl => { :ca_file => "#{Rails.root}/config/ca-bundle.crt" }, :full_host => 'http://89.21.94.196:9999/'}
   provider :twitter, 	'ztZvlKRqng15cOc6tknSA', 'l2tsiCbw81r4xoKlQtaSgZyx9HMiqZYZum4OTalPXE', :client_options => { :ssl => { :ca_file => "#{Rails.root}/config/ca-bundle.crt" }}
   #provider :github, 'CLIENT ID', 'SECRET'

   # generic openid
   provider :openid, :store => OpenID::Store::Filesystem.new('/tmp'), :name => 'openid'

   # dedicated openid
   provider :openid, :store => OpenID::Store::Filesystem.new('/tmp'), :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'
   # provider :google_apps, OpenID::Store::Filesystem.new('./tmp'), :name => 'google_apps'
   # /auth/google_apps; you can bypass the prompt for the domain with /auth/google_apps?domain=somedomain.com

   provider :openid, :store => OpenID::Store::Filesystem.new('/tmp'), :name => 'yahoo', :identifier => 'yahoo.com'
   provider :openid, :store => OpenID::Store::Filesystem.new('/tmp'), :name => 'aol', :identifier => 'openid.aol.com'
   provider :openid, :store => OpenID::Store::Filesystem.new('/tmp'), :name => 'myopenid', :identifier => 'myopenid.com'

   # Sign-up urls for Facebook, Twitter, and Github
   # https://developers.facebook.com/setup
   # https://github.com/account/applications/new
   # https://developer.twitter.com/apps/new
end