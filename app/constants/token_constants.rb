module TokenConstants
  LOGIN_USER_ACCESS = 'LOGIN::USER_ACCESS'.freeze

  LOGIN_USER_ACCESS_EXPIRY = 4.hours.since.utc
  LOGIN_USER_REFRESH_EXPIRY = 2.days.since.utc
end
