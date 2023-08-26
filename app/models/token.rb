class Token < ApplicationRecord
  include HasherHelper

  self.primary_key = :hashed_token

  attr_accessor :session_token, :session_refresh_token

  belongs_to :user, class_name: 'User', foreign_key: 'resource_id'

  validates :session_token, :token_type, :resource_id, presence: true

  def expired?
    expires_at <= 10.minutes.since.utc
  end

  def refresh_token_expired?
    return false unless refresh_expires_at.present?

    refresh_expires_at <= 10.minutes.since.utc
  end

  def expire!
    self.expires_at = 15.minutes.ago.utc
    self.refresh_expires_at = 15.minutes.ago.utc
    self.revoked = true

    save!
  end

  class << self
    def generate_token_for(field:)
      loop do
        token = SecureRandom.hex(32)
        return token unless Token.exists?("#{field}": HasherHelper.digest(token))
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
        resource_type: 'user',
        revoked: false
      )

      t.hashed_token = HasherHelper.digest(t.session_token)
      t.hashed_refresh_token = HasherHelper.digest(t.session_refresh_token)

      t.save
      t
    end

    def find_by_token(access_token, refreshtoken)
      refresh_token_hashed = HasherHelper.digest(refreshtoken)
      token = Token.find_by!(hashed_token: HasherHelper.digest(access_token), revoked: false)

      token.session_token = access_token
      token.session_refresh_token = refreshtoken

      return nil unless token.present?
      return nil if token.expired? && token.hashed_refresh_token != refresh_token_hashed
      return nil if token.refresh_token_expired?

      if token.expired? && token.hashed_refresh_token == refresh_token_hashed # just to be safe
        access_token = Token.generate_token_for(field: 'hashed_token')
        token.session_token = access_token
        token.hashed_token = HasherHelper.digest(access_token)

        token.expires_at = TokenConstants::LOGIN_USER_ACCESS_EXPIRY
        token.save!
      end

      p 'token validate success'

      token
    end
  end
end
