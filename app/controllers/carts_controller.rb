class CartsController < ApplicationController
  include ApplicationHelper

  before_action :logged_in?
  before_action :validate_token, only: %i[show]

  # For registered users
  # get user_id from session[:user].id
  # get cart_token if cart_state: "processing"
  # For unregistered users return :unauthorized

  def edit; end

  def guest_order
    @product_item = ProductItem.includes(:product).find_by!(id: guest_cart_items[:item_id])
    @product = @product_item.product
    @form = GuestOrderBuilderForm.new
    @form.order_item_builder = guest_cart_items.slice(:item_id, :size, :quantity)

    @shipping = 0
    @discount = 0
    @outofstock = @product_item.quantity <= 0
    @total_amount = @product.price.to_i * guest_cart_items[:quantity].to_i

    @show_payment = false

    add_breadcrumb('Products', products_url)
    add_breadcrumb(@product.title, product_url(@product))
    add_breadcrumb('Checkout', nil, true)
  end

  def show
    raise ActiveRecord::RecordNotFound unless cart_items.present?

    @cart_items = Cart
                  .includes(:product_item)
                  .joins(:product_item)
                  .where(
                    cart_token:,
                    cart_state: 'processing',
                    user_id: current_user.user_id
                  )

    @form = GuestOrderBuilderForm.new
  end

  def update
    item_props = ItemProperties.new(place_order_params.slice(:size, :color, :quantity))
    item_id = place_order_params[:item_id]
    cart_items_count = 0

    @cart = Cart.build_with_items(item_props:, item_id:)

    if current_cart.present? && current_cart.find { |cart| cart.product_item_id == item_id }.present?
      p 'current item is already updated'

      @cart_error_msgs = ['Only allowed to buy one']

      return respond_to do |format|
        format.html do
          flash[:error] = 'Something went wrong when adding to cart'
          redirect_back fallback_location: product_url(item_id), status: 422
        end

        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            'cart-errors',
            partial: 'products/cart_error',
            locals: { cart_error_msgs: @cart_error_msgs }
          )
        end
      end
    end

    if current_cart.present?
      p 'cart is already present adding item'
      existing_cart = current_cart.first

      @cart.cart_id = existing_cart.cart_id
      @cart.cart_token = existing_cart.cart_token
      @cart.cart_token_expires_at = existing_cart.cart_token_expires_at

      cart_items_count = current_cart.count(1)
    else
      p 'building new cart'
      @cart.cart_id = Cart.build_id
      @cart.cart_token = Cart.build_token
    end

    @cart.user_id = current_user.id

    if @cart.valid? && @cart.save
      p 'saving to cart'

      session[:cart_token] = @cart.cart_token

      return respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            'cart-items-count',
            partial: 'layouts/cart_items_count',
            locals: { cart_items_count: cart_items_count + 1 }
          )
        end

        format.html do
          flash.now[:success] = 'Item added to cart'
          redirect_back fallback_location: product_url(item_id), status: 201
        end
      end
    end

    p 'error while finding cart or building'
    @cart_error_msgs = @cart.errors.full_messages

    respond_to do |format|
      format.html do
        flash[:error] = 'Something went wrong when adding to cart'
        redirect_back fallback_location: product_url(item_id), status: 422
      end

      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          'cart-errors',
          partial: 'products/cart_error',
          locals: { cart_error_msgs: @cart_error_msgs }
        )
      end
    end
  end

  def destroy; end

  private

  def validate_token
    raise ::Unauthorized unless current_cart&.first&.cart_token == params[:token]
  end

  def guest_cart_items
    cart_token = session[:cart_token]
    raise ActiveRecord::RecordNotFound unless cart_token.present?
    raise ::Unauthorized unless cart_token == cart_token_in_params
    raise ActiveRecord::RecordNotFound unless session[cart_token].present?

    @guest_cart_items ||= HashWithIndifferentAccess.new session[cart_token]
  end

  def cart_items
    @cart_items ||= Cart.product_items_for_user(current_user.user_id)
  end

  def place_order_params
    params.require(:guest_buy_form).permit(:item_id, :size, :color, :quantity)
  end

  def cart_token_in_params
    params.fetch(:token, '')
  end
end
