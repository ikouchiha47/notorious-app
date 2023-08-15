class User < ApplicationRecord
  include Uidable
  include BCrypt

  GUEST_USER = 'guest'.freeze
  UNVERIFIED_USER = 'unverified'.freeze
  VERIFIED_USER = 'verified'.freeze

  validates :email, :user_type, :country_code, :number, presence: true
  validates :email, email_format: true

  validates :country_code, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 999
  }
  validates :number, length: { in: 6..20 }

  has_many :addresses

  def authenticate(plain_password)
    password == plain_password
  end

  def password
    @password ||= Password.new(hashed_password)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.hashed_password = @password
  end

  def guest?
    user_type == GUEST_USER and !user.verified
  end

  def member?
    user_type == UNVERIFIED_USER || user_type == VERIFIED_USER
  end

  def verified?
    user_type == VERIFIED_USER
  end

  class << self
    def create_guest_user(email:, password:)
      opts = {
        email:,
        password:,
        verified: false,
        user_type: GUEST_USER,
        country_code: 0,
        number: 1_000_000
      }

      User.create(opts)
    end

    def create_unverified_user(email:, password:)
      opts = {
        email:,
        password:,
        verified: false,
        user_type: UNVERIFIED_USER,
        country_code: 0,
        number: 1_000_000
      }

      User.create(opts)
    end
  end
end
