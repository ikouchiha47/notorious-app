class CheckoutsController < ApplicationController
  def guest_buy
    order = OrderItemBuilder.new(guest_buy_params)
    raise Unprocessible unless order.valid?

    session[:cart_token] = cart_token
    session[cart_token] = guest_buy_params

    redirect_to guest_order_carts_url(token: cart_token)
  end

  def create
    @product_item = ProductItem.includes(:product).find_by!(id: order_item[:item_id])
    @product = @product_item.product

    @outofstock = @product_item.quantity <= 0
    # shouldn't have come here, get that fucker back to products listing
    redirect_to products_url and return if @outofstock

    @shipping = 0
    @total_amount = @product.price.to_i * order_item[:quantity].to_i

    @form = GuestOrderBuilderForm.new(*guest_order_builder_form)

    unless @form.valid?
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            'guest-checkout-form',
            partial: 'carts/form',
            locals: {
              form: @form,
              total_amount: @total_amount,
              shipping: @shipping,
              outofstock: @outofstock,
              show_payment: false,
              order_token: nil
            }
          )
        end
      end

      return
    end

    begin
      @form.save!
      @success = true

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            'guest-checkout-form',
            partial: 'carts/form',
            locals: {
              form: @form,
              total_amount: @total_amount,
              shipping: @shipping,
              outofstock: false,
              show_payment: true,
              order_token: @form.order.order_token
            }
          )
        end
      end
    rescue StandardError => e
      p e
      @guest_order_error = 'Something went wrong'

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            'guest-checkout-form',
            partial: 'carts/form',
            locals: {
              form: @form,
              total_amount: @total_amount,
              shipping: @shipping,
              outofstock: @outofstock,
              show_payment: false,
              order_token: nil
            }
          )
        end
      end
    end
  end

  private

  def cart_token
    @cart_token ||= SecureRandom.urlsafe_base64(32, false)
  end

  def can_buy_product; end

  def review_order_params
    params.require(:checkout).permit(:item_ids)
  end

  def guest_buy_params
    params.require(:guest_buy_form).permit(:item_id, :size, :quantity)
  end

  def order_item
    guest_order_builder_form[:order_item_builder]
  end

  def guest_order_builder_form
    params.require(:guest_order_builder_form).permit(
      :email,
      :address_line_a,
      :address_line_b,
      :zip_code,
      :phone_country_code,
      :phone_number,
      order_item_builder: %i[item_id size quantity]
    )
  end
end
