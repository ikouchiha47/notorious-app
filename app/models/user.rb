class User < ApplicationRecord
  include Uidable
  include BCrypt

  GUEST_USER = 'guest'

  validates :email, :user_type, :country_code, :number, presence: true
  validates :country_code, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 999
  }
  validates :number, length: { in: 6..20 }


  has_many :addresses

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

  def is_guest?
    user.type == "guest" and user.verified
  end
end
