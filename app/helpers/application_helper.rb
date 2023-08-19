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
    return nil unless session[:access_token].present? && session[:refresh_token].present?

    @current_token ||= Token.find_by_token(session[:access_token], session[:refresh_token])
  end

  def current_cart
    @current_cart ||= Cart.where(cart_token: session[:cart_token])
  end

  def logged_in?
    session[:access_token].present? && session[:refresh_token].present?
  end

  def flashes(type, texts)
    flash[type] ||= []
    flash[type].concat texts
  end
end
