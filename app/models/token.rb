class Token < ApplicationRecord
  include BCrypt

  attr_accessor :session_token, :session_refresh_token

  belongs_to :user, class_name: 'User', foreign_key: 'resource_id'

  validates :token, :token_type, :resource_id, presence: true

  def token=(access_token)
    @token = Password.create(access_token)
    self.hashed_token = @token
  end

  def token
    @token ||= Password.new(hashed_token)
  end

  def refresh_token=(token)
    @refresh_token = Password.create(token)
    self.hashed_refresh_token = @refresh_token
  end

  def refresh_token
    @refresh_token ||= Password.new(hashed_refresh_token)
  end

  def expired?
    expires_at <= TokenConstants::LOGIN_USER_ACCESS_EXPIRY - 10.minutes
  end

  def refresh_token_expired?
    return false unless refresh_expires_at.present?

    refresh_expires_at <= TokenConstants::LOGIN_USER_REFRESH_EXPIRY - 10.minutes
  end

  def expire!
    update!(
      expires_at: 15.minutes.ago.utc,
      refresh_expires_at: 15.minutes.ago.utc,
      revoked: true
    )
  end

  class << self
    def generate_token_for(field:)
      loop do
        token = SecureRandom.hex(32)
        return token unless Token.exists?("#{field}": BCrypt::Password.create(token))
      end
    end

    def create_user_login_token(user_id)
      t = Token.new(
        expires_at: ::TokenConstants::LOGIN_USER_ACCESS_EXPIRY,
        session_token: ::Token.generate_token_for(field: 'hashed_token'),
        refresh_expires_at: TokenConstants::LOGIN_USER_REFRESH_EXPIRY,
        session_refresh_token: Token.generate_token_for(field: 'hashed_refresh_token'),
        token_type: TokenConstants::LOGIN_USER_ACCESS,
        resource_id: user_id,
        revoked: false
      )
      t.token = t.session_token
      t.refresh_token = t.session_refresh_token

      t.save
      t
    end

    def find_by_token(access_token, refreshtoken)
      p access_token
      token = Token.where(hashed_token: BCrypt::Password.create(access_token), revoked: false)

      return nil unless token.present?
      return nil if token.expired? || token.refresh_token != refreshtoken
      return nil if token.refresh_token_expired?

      if token.expired? && token.refresh_token == refreshtoken # just to be safe
        access_token = Token.generate_token_for(field: 'hashed_token')
        token.token = access_token
        token.expires_at = TokenConstants::LOGIN_USER_ACCESS_EXPIRY
        token.save
      else
        token.touch
      end

      token.session_token = access_token
      token
    end
  end
end
