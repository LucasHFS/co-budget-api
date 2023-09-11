# frozen_string_literal: true

class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :orders, dependent: :restrict_with_error
  has_many :deliveries, dependent: :restrict_with_error

  enum :role, user: 1, client: 2, driver: 3

  scope :clients, lambda {
    where(role: 'client')
  }

  scope :drivers, lambda {
    where(role: 'driver')
  }

  before_validation do
    unless user?
      random_string = SecureRandom.uuid
      self.email = random_string if email.blank?
      self.password = random_string if password.blank?
      save(validate: false)
    end
  end

  def generate_jwt
    Warden::JWTAuth::UserEncoder
      .new
      .call(self, :user, nil)
      .first
  end
end
