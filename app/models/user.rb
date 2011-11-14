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

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    where(conditions).where(["lower(login) = :value", {:value => login.downcase}]).first
  end

  protected

  # Attempt to find a user by it's email. If a record is found, send new
  # password instructions to it. If not user is found, returns a new user
  # with an email not found error.
  def self.send_reset_password_instructions(attributes={})
    recoverable = find_recoverable_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
    recoverable.send_reset_password_instructions if recoverable.persisted?
    recoverable
  end

  def self.find_recoverable_or_initialize_with_errors(required_attributes, attributes, error=:invalid)
    (case_insensitive_keys || []).each { |k| attributes[k].try(:downcase!) }

    attributes = attributes.slice(*required_attributes)
    attributes.delete_if { |key, value| value.blank? }

    if attributes.size == required_attributes.size
      if attributes.has_key?(:login)
        login = attributes.delete(:login)
        record = find_record(login)
      else
        record = where(attributes).first
      end
    end

    unless record
      record = new

      required_attributes.each do |key|
        value = attributes[key]
        record.send("#{key}=", value)
        record.errors.add(key, value.present? ? error : :blank)
      end
    end
    record
  end

  def self.find_record(login)
    where(["login = :value", {:value => login}]).first
  end

end
