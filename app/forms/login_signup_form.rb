class LoginSignupForm
  include ActiveModel::Model

  attr_accessor :email, :password, :user_type

  validates_presence_of :email, :password
  validates :email, email_format: true
  validates_length_of :password, minimum: 8

  attr_reader :token, :user, :success

  def initialize(opts = {})
    super(opts)

    @success = false
  end

  def login!
    @user = User.find_by(email:)
    raise Accounts::LoginUserNotFound unless user.present?

    raise Accounts::SignupUserExists if @user.guest?
    raise Accounts::LoginUserNotFound unless @user.member? && @user.authenticate(password)

    @token = Token.create_user_login_token(@user.id)
    raise Accounts::TokenCreationFailed unless @token.present? && @token.valid?

    @success = true
  end

  def signup!
    @user = User.find_by(email:)
    raise Accounts::SignupUserExists if @user.present?

    @user = User.create_unverified_user(email:, password:)
    raise Accounts::CreateUserFailed, @user.errors.full_messages unless @user.valid?

    @token = Token.create_user_login_token(@user.id)
    raise Accounts::TokenCreationFailed, @user.errors.full_messages unless @token.valid?

    @success = true
  end
end
