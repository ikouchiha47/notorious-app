module ApplicationHelper
  def format_price(price, location = '')
    Money.from_cents(price, "INR").format
  end

  def country_code_list
    # ISO3166::Country.codes.map do |code|
    #   c = ISO3166::Country.new(code)
    #   ["#{c.country_code}- #{c.alpha2}", c.country_code]
    # end

    c = ISO3166::Country.new('IN')
    [["#{c.country_code}- #{c.alpha2}", c.country_code]]
  end

  def user_token
  end

  def current_user
  end

  def logged_in?
    !!session[:user_token]
  end
end
