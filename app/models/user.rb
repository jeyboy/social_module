class User < ActiveRecord::Base
  has_many :services, :dependent => :destroy
  accepts_nested_attributes_for :services

  # :token_authenticatable, :encryptable, :confirmable, :validatable, :lockable, :timeoutable, :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable

  attr_accessible :login, :fullname, :email, :password, :password_confirmation, :remember_me, :services_attributes

  validates :login, :presence => true, :uniqueness => true, :length => {:minimum => 6, :maximum => 20}
  validates :fullname, :presence => true
  validates :email, :presence => true, :uniqueness => true, :format => {:with => Devise.email_regexp}
  validates :password, :presence => true, :confirmation => true, :length => {:minimum => 6}, :if => :password_require?


  protected
  def password_require?
    new_record? || !password.nil? || !password_confirmation.nil?
  end
end
