class Service < ActiveRecord::Base
  belongs_to :user
  serialize :credentials
  attr_accessible :provider, :uid, :credentials

  validates :user, :provider, :uid, :credentials, :presence => true
  #validates :provider, :inclusion => { :in => self.providers_list.map&:service_name }

  def self.providers_list
    [{:image_name => 'google', :service_name => 'google_oauth2'}, {:image_name => 'twitter', :service_name => 'twitter'}, {:image_name => 'facebook', :service_name => 'facebook'}]
  end

  def provider_name
    if provider == 'google_oauth2'
      "google"
    else
      provider
    end
  end

  def facebook
    @fb_user ||= FbGraph::User.me(credentials['token'])
  end

  def twitter
    @tw_user ||= prepare_access_token
  end

  def write(text, feed_name)
    begin
      case self.provider
        when 'facebook' then
          facebook.feed!(:message => text, :name => feed_name)
        when 'twitter' then
          twitter.request(:post, "http://api.twitter.com/1/statuses/update.json", :status => text)
        when 'google_oauth2' then
          write_google_activity(text)
      end
    rescue Exception => e
    end
  end

  def read
    begin
      case self.provider
        when 'facebook' then
          info = facebook.posts.collection.to_a
          #info = info.inject([]) {|ret, elem| ret << {:name => elem['from']['name'], :time => elem['created_time'], :text => elem['message'] || elem['story']}}
        when 'twitter' then
          info = twitter.request(:get, "http://api.twitter.com/1/statuses/home_timeline.json").body
          #info = JSON::parse(info).inject([]) {|ret, elem| ret << {:name => elem['user']['name'], :time => elem['created_at'], :text => elem['text']}}
          info = JSON::parse(info).inject([]) {|ret, elem| ret << {:name => elem['user']['name'], :name_link => elem['user']['url'], :photo => elem['user']['profile_image_url'], :time => elem['created_at'], :text => elem['text']}}
        when 'google_oauth2' then
          info = read_google_activities
          info = info.inject([]) {|ret, elem| ret << {:name => elem['actor']['displayName'], :name_link => elem['actor']['url'], :photo => elem['actor']['image']['url'] , :time => elem['published'], :text => elem['title'] , :text_link => elem['url']}}
      end
    rescue Exception => e
    end
    {:provider => self.provider_name, :data => (info || [])}
  end

  protected

  def prepare_access_token
    consumer = OAuth::Consumer.new(TWITTER_KEY, TWITTER_SECRET, {:site => "http://api.twitter.com"})
    # now create the access token object from passed values
    token_hash = {:oauth_token => credentials['token'], :oauth_token_secret => credentials['secret']}
    access_token = OAuth::AccessToken.from_hash(consumer, token_hash)
  end

  def read_google_activities
    c = Curl::Easy.new("https://www.googleapis.com/plus/v1/people/me/activities/public?alt=json&pp=1&key=#{GOOGLE_APP}&access_token=#{credentials['token']}")
    c.perform
    JSON.parse(c.body_str)['items']
  end

  def write_google_activity(text)

  end
end
