module ProductsHelper
  include ApplicationHelper

  def size_options_for_select(size_chart = [])
    size_chart.map do |chart|
      [size_to_text(chart), chart[:size]]
    end
  end

  def size_to_text(chart)
    chart[:size].to_s
  end

  # checks if the product item is already added to cart
  # we assume that current_user will be there, we need to validate on cart_token
  def can_add_to_cart?(item_id)
    return false unless current_user.present? && current_user.member?
    return true unless current_cart.present?

    !current_cart.find { |cart| cart.product_item_id == item_id }.present?
  end

  # TODO: see if we need to add @cart_error_messages here
  def buttton_class_for_add_to_cart(item_id)
    return 'enabled' if can_add_to_cart?(item_id)

    'disabled'
  end
end
