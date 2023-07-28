class User < ApplicationRecord
  include Uidable
  include BCrypt

  def password
    @password ||= Password.new(hashed_password)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.hashed_password = @password
  end

  def create_guest_user
    User.first_or_create!(
      password: 'ikea',
      country_code: 0,
      number: 0,
      verified: false,
      email: 'vindy.ssa@mailinator.com'
    )
  end
end
