class User < ActiveRecord::Base
  has_many :services, :dependent => :destroy

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :validatable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :login, :fullname, :email, :password, :password_confirmation, :remember_me

  def apply_omniauth(omniauth)
    self.email = omniauth['info']['email'] if email.blank?
    services.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end

  def password_required?
    (services.empty? || !password.blank?) && super
  end
end
