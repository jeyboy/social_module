class Service < ActiveRecord::Base
  inclusion_list = ['google_oauth2', 'twitter', 'facebook']

  belongs_to :user
  serialize :credentials
  attr_accessible :provider, :uid, :credentials

  validates :provider, :uid, :credentials, :presence => true
  validates :provider, :inclusion => { :in => inclusion_list }
  validates :user_id, :presence => true, :if => :is_not_new_record?

  scope :for_provider, lambda {|service| where(:provider => service)}

  def is_not_new_record?
    !new_record?
  end

  def provider_name
    provider == 'google_oauth2' ? "google" : provider
  end

  def facebook
    @fb_user ||= FbGraph::User.me(credentials['token'])
  end

  def twitter
    @tw_user ||= prepare_access_token
  end

  def read
    begin
      info = case self.provider
        when 'facebook' then
          facebook.posts.collection.to_a
        when 'twitter' then
          twit = twitter.request(:get, "http://api.twitter.com/1/statuses/home_timeline.json").body
          JSON::parse(twit).inject([]) {|ret, elem| ret << {:name => elem['user']['name'], :name_link => elem['user']['url'], :photo => elem['user']['profile_image_url'], :time => elem['created_at'], :text => elem['text']}}
        when 'google_oauth2' then
          read_google_activities.inject([]) {|ret, elem| ret << {:name => elem['actor']['displayName'], :name_link => elem['actor']['url'], :photo => elem['actor']['image']['url'] , :time => elem['published'], :text => elem['title'] , :text_link => elem['url']}}
      end
    rescue Exception => e
    end
    {:provider => self.provider_name, :data => (info || [])}
  end

  protected

  def prepare_access_token
    consumer = OAuth::Consumer.new(TWITTER_KEY, TWITTER_SECRET, {:site => "http://api.twitter.com"})
    token_hash = {:oauth_token => credentials['token'], :oauth_token_secret => credentials['secret']}
    OAuth::AccessToken.from_hash(consumer, token_hash)
  end

  def read_google_activities
    check_and_update_token
    c = Curl::Easy.new("https://www.googleapis.com/plus/v1/people/me/activities/public?alt=json&pp=1&key=#{GOOGLE_APP}&access_token=#{credentials['token']}")
    c.perform
    JSON.parse(c.body_str)['items']
  end

  def check_and_update_token
    if credentials['expires']
      if Time.at(credentials['expires_at'].to_i) < Time.now
        c = Curl::Easy.http_post("https://accounts.google.com/o/oauth2/token", Curl::PostField.content('client_id', GOOGLE_KEY), Curl::PostField.content('client_secret', GOOGLE_SECRET), Curl::PostField.content('refresh_token', credentials['refresh_token']), Curl::PostField.content('grant_type', 'refresh_token'))
        c.perform
        data = JSON.parse(c.body_str)
        self.update_attribute(:credentials, credentials.to_hash.update({'token' => data['access_token'], 'expires_at' => (Time.now.to_i + data['expired_in'].to_i)}))
      end
    end
  end
end
