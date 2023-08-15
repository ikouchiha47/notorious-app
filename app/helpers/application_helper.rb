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

  def user_token; end

  def current_user; end

  def logged_in?
    session[:access_token].present? && session[:refresh_token].present?
  end

  def flashes(type, texts)
    flash[type] ||= []
    flash[type].concat texts
  end
end
