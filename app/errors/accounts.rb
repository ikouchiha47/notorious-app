module Accounts
  class SignupUserExists < StandardError
    def message
      <<-HEREDOC
      An account with this email already exists.
      In case you haven't yet registered with us, please reset the password.
      HEREDOC
    end
  end

  class LoginUserNotFound < StandardError
    def message
      <<-HEREDOC
      The email and/or password combination was invalid.
      Please try to signup or reset password.
      HEREDOC
    end
  end

  class LoginInvalidCredentials < StandardError
    def message
      LoginUserNotFound.new.message
    end
  end

  class CreateUserFailed < StandardError
    attr_accessor :error

    def message
      p error
      'Something went wrong. Please try again, or contact us'.freeze
    end
  end

  class TokenCreationFailed < StandardError
    attr_accessor :error

    def message
      p error
      'Something went wrong. Please try again, or contact us'.freeze
    end
  end
end
