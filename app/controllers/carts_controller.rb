class CartsController < ApplicationController
  include ApplicationHelper

  before_action :logged_in?
  before_action :set_cart_error_and_success_vars
  before_action :add_parent_crumb, only: %i[guest_order show]

  after_action :add_end_crumb, only: %i[guest_order show]

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
    @form.address_form_builder = {}

    @shipping = 0
    @discount = 0
    @outofstock = @product_item.quantity <= 0
    @total_amount = @product.price.to_i * guest_cart_items[:quantity].to_i

    @show_payment = false

    add_breadcrumb(@product.title, product_url(@product))
  end

  def show
    # calling cart_items here sets the @cart_items to be in view
    p 'showoff'
    unless cart_items.present?
      flash[:notice] = 'You cart is empty'
      p 'cart empty'
      return redirect_back(fallback_location: products_url), status: 200
    end

    @addresses = Address.viewable(current_user.id)
    @pricing = Pricing.new(items_in_cart: cart_items)
    @form = AddressFormBuilder.new
    @show_payment = false
    @order_form = MyOrderBuilderForm.new
  end

  def update
    item_props = ItemProperties.new(place_order_params.slice(:size, :color, :quantity))
    item_id = place_order_params[:item_id]
    @cart_items_count = 0

    @cart = Cart.build_with_items(item_props:, item_id:)

    if current_cart.present? && current_cart.find { |cart| cart.product_item_id == item_id }.present?
      p 'current item is already updated'

      @cart_error_msgs << ['Only allowed to buy one']

      return respond_to do |format|
        format.html do
          flash[:error] = 'Something went wrong when adding to cart'
          redirect_back fallback_location: product_url(item_id), status: 422
        end

        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            'cart-errors',
            partial: 'products/cart_messages',
            locals: { errors: @cart_error_msgs, success: [] }
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

      @cart_items_count = current_cart.count(1)
    else
      p 'building new cart'
      @cart.cart_id = Cart.build_id
      @cart.cart_token = Cart.build_token
    end

    @cart.user_id = current_user.id

    if @cart.valid? && @cart.save
      p 'saving to cart'

      session[:cart_token] = @cart.cart_token
      @cart_success_msgs << 'Added to cart'

      return respond_to do |format|
        format.turbo_stream

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
          partial: 'products/cart_messages',
          locals: { errors: @cart_error_msgs, success: [] }
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
    raise ::Unauthorized unless session[:cart_token].present?

    @cart_items ||= Cart.product_items_for_user(current_user.id, session[:cart_token])
  end

  def place_order_params
    params.require(:guest_buy_form).permit(:item_id, :size, :color, :quantity)
  end

  def cart_token_in_params
    params.fetch(:token, '')
  end

  def add_parent_crumb
    add_breadcrumb('Products', products_url)
  end

  def add_end_crumb
    add_breadcrumb('Checkout', nil, true)
  end
end
