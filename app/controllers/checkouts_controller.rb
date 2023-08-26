class CheckoutsController < ApplicationController
  def create
    unless current_cart.present?
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            'order-form-error',
            partial: 'carts/order_error',
            locals: {
              errors: ['Something is not right. Please logout and login again.']
            }
          )
        end
      end

      return
    end

    if Order.exists?(cart_id: current_cart.first.cart_id)
      @errors = ['Order is already created, We will get back to you in case.']
      respond_to do |format|
        format.turbo_stream
      end

      return
    end

    @form = MyOrderBuilderForm.new(my_order_builder_params)

    unless @form.valid?
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            'order-form-error',
            partial: 'carts/order_error',
            locals: {
              errors: @form.errors.full_messages
            }
          )
        end
      end

      return
    end

    begin
      @form.save!

      respond_to do |format|
        format.turbo_stream
      end
    rescue StandardError => e
      @errors = [e.message]
      respond_to do |format|
        format.turbo_stream
      end
    end
  end

  # for guest_buy in future maybe put it in a different controller
  def guest_buy
    order = OrderItemBuilder.new(guest_buy_params)
    raise Unprocessible unless order.valid?

    session[:cart_token] = cart_token
    session[cart_token] = guest_buy_params

    redirect_to guest_order_carts_url(token: cart_token)
  end

  def guest_create
    @product_item = ProductItem.includes(:product).find_by!(id: order_item[:item_id])
    @product = @product_item.product

    @outofstock = @product_item.quantity <= 0
    # shouldn't have come here, get that fucker back to products listing
    redirect_to products_url and return if @outofstock

    @shipping = 0
    @total_amount = @product.price.to_i * order_item[:quantity].to_i

    begin
      @form = GuestOrderBuilderForm.new(*guest_order_builder_form)

      unless @form.valid?
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace(
              'guest-checkout-form',
              partial: 'carts/guest_form',
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

      @form.save!
      @success = true

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            'guest-checkout-form',
            partial: 'carts/guest_form',
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
      @guest_order_error = if e.is_a? ActiveRecord::RecordNotUnique
                             'You have already shopped with us. Please consider logging of reset password'
                           elsif e.is_a? ActiveRecord::RecordInvalid
                             'You have already shopped with us. Please consider logging of reset password'
                           else
                             'Something went wrong'
                           end

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            'guest-checkout-form',
            partial: 'carts/guest_form',
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

  def my_order_builder_params
    my_order_builder_form.merge(user_id: current_user.id, cart_token: current_cart.first.cart_token)
  end

  def my_order_builder_form
    params.require(:my_order_builder_form).permit(:address_id)
  end

  def guest_buy_params
    params.require(:guest_buy_form).permit(:item_id, :size, :quantity)
  end

  def order_item
    guest_order_builder_form[:order_item_builder]
  end

  def address_item
    guest_order_builder_form[:address_form_builder]
  end

  def guest_order_builder_form
    params.require(:guest_order_builder_form).permit(
      :email,
      :phone_country_code,
      :phone_number,
      order_item_builder: %i[item_id size quantity],
      address_form_builder: %i[address_line_a address_line_b zip_code]
    )
  end
end
