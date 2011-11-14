class Service < ActiveRecord::Base
  belongs_to :user
  attr_accessible :provider, :uid, :token, :secret

  def provider_name
    if provider == 'open_id'
      "OpenID"
    else
      provider.titleize
    end
  end

  def facebook
    @fb_user ||= FbGraph::User.me(:token)
  end

  def twitter
    @tw_user ||= prepare_access_token(token, secret)
  end

  def write(text, feed_name)
    begin
      case self.provider
        when 'facebook' then
          facebook.feed!(:message => text, :name => feed_name)
        when 'twitter' then
          twitter.request(:post, "http://api.twitter.com/1/statuses/update.json", :status => text)
      end
    rescue Exception => e
    end
  end

  def read()
    begin
      case self.provider
        when 'facebook' then
          info = facebook.posts
        when 'twitter' then
          info = twitter.request(:get, "http://api.twitter.com/1/statuses/home_timeline.json").body
          info = JSON::parse(info).inject([]) {|ret, elem| ret << {:name => elem['user']['name'], :time => elem['created_at'], :text => elem['text']}}
      end
    rescue Exception => e
    end
    info
  end

  protected

  def prepare_access_token(oauth_token, oauth_token_secret)
    consumer = OAuth::Consumer.new(TWITTER_KEY, TWITTER_SECRET, {:site => "http://api.twitter.com"})
    # now create the access token object from passed values
    token_hash = {:oauth_token => oauth_token, :oauth_token_secret => oauth_token_secret}
    access_token = OAuth::AccessToken.from_hash(consumer, token_hash)
  end
end
