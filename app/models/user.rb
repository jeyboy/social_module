class User < ActiveRecord::Base
  has_many :services, :dependent => :destroy

  # :token_authenticatable, :encryptable, :confirmable, :validatable, :lockable, :timeoutable, :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable

  attr_accessible :login, :fullname, :email, :password, :password_confirmation, :remember_me

  validates :login, :presence => true, :uniqueness => true
  validates :fullname, :presence => true
end
