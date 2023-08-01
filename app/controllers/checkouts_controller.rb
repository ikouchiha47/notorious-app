class CheckoutsController < ApplicationController
  def guest_buy
    order = OrderItemBuilder.new(guest_buy_params)
    raise Unprocessible unless order.valid?

    session[:cart_token] = cart_token
    session[cart_token] = guest_buy_params

    redirect_to guest_order_carts_url(token: cart_token)
  end

  def create
    @form = GuestOrderBuilderForm.new(*guest_order_builder_form)
    p @form.zip_code
    p @form.phone_country_code
    p @form.valid?
    p @form.errors.messages
    p @form.save!
  end

  private

  def cart_token
    @cart_token ||=SecureRandom.urlsafe_base64(32, false)
  end

  def review_order_params
    params.require(:checkout).permit(:item_ids)
  end

  def guest_buy_params
    params.require(:guest_buy_form).permit(:item_id, :size, :quantity)
  end

  def guest_order_builder_form
    params.require(:guest_order_builder_form).permit(
      :email,
      :address_line_a,
      :address_line_b,
      :zip_code,
      :phone_country_code,
      :phone_number,
      order_item_builder: [:item_id, :size, :quantity]
    )
  end
end
