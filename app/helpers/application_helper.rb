module ApplicationHelper
  def format_price(price, location = '')
    Money.from_cents(price, "INR").format
  end
end
