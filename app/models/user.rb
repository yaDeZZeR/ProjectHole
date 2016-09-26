class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :rememberable,
         :validatable

  before_save :ensure_authentication_token

  validates :login, presence: true, uniqueness: true
  validates :password_confirmation, presence: true

  # Токен - главный ID. Должен существовать, и не должен повторяться.
  validates :device_token, presence: true, uniqueness: true
  validates :platform, presence: true

  has_many :locations

  # Типы платформ
  enum platform: [:android, :ios]

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  # Заполняет объект пользователя данными для создания по токену устройства.
  # Нужно вызвать метод save для сохранения его в БД.
  # Если пользователь уже существует, обнуляет его информацию.
  def self.new_from_device_info(device_token, platform, login, password)
    user = User.new({
      login: login,
      password: password,
      password_confirmation: password,
      device_token: device_token,
      platform: platform
    })
  end

  private

    def email_required?
      false
    end

    def email_changed?
      false
    end

    def generate_authentication_token
      loop do
        token = Devise.friendly_token
        break token unless User.where(authentication_token: token).first
      end
    end
end