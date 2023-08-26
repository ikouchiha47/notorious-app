module ApplicationHelper
  def format_price(price, _location = '')
    Money.from_cents(price, 'INR').format
  end

  def country_code_list
    # ISO3166::Country.codes.map do |code|
    #   c = ISO3166::Country.new(code)
    #   ["#{c.country_code}- #{c.alpha2}", c.country_code]
    # end

    c = ISO3166::Country.new('IN')
    [["#{c.country_code}- #{c.alpha2}", c.country_code]]
  end

  def guest_user
    User.new(id: nil)
  end

  def current_user
    raise ::Unauthorized unless current_token.present? && current_token.valid?

    @current_user ||= User.find_by!(id: current_token.resource_id)
  end

  def current_token
    raise Unauthorized unless session[:access_token].present? && session[:refresh_token].present?

    # p session[:access_token]
    # p 'before'
    @current_token ||= Token.find_by_token(session[:access_token], session[:refresh_token])
    # p @current_token.session_token

    session[:access_token] = @current_token.session_token unless @current_token.session_token == session[:access_token]
    # p @current_token.session_token
    # p 'after'
    # p session[:access_token]

    @current_token
  end

  def current_cart
    @current_cart ||= Cart.where(cart_token: session[:cart_token])
  end

  def logged_in?
    current_token.present?
  rescue StandardError
    false
  end

  def flashes(type, texts)
    flash[type] ||= []
    flash[type].concat texts
  end

  def simple_mask(value, unmask_len = 4)
    return value unless value.present? || value.length < unmask_len

    unmasked = value.slice(0, unmask_len)
    masked = 'X' * (value.length - unmask_len)

    "#{unmasked}#{masked}"
  end
end
