class User < ActiveRecord::Base
  has_many :services, :dependent => :destroy

  # :token_authenticatable, :encryptable, :confirmable, :validatable, :lockable, :timeoutable, :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable

  #attr_accessor :login, :fullname
  attr_accessible :login, :fullname, :email, :password, :password_confirmation, :remember_me

  validates :login, :presence => true, :uniqueness => true

  #def apply_omniauth(omniauth)
  #  #self.email = omniauth['info']['email'] if email.blank?
  #  #self.login =  if login.blank?
  #  services.build(:provider => omniauth['provider'], :uid => omniauth['uid'], :auth_hash => omniauth)
  #end

  def password_required?
    (services.empty? || !password.blank?) && super
  end
end
