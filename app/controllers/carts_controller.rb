class CartsController < ApplicationController
  include ApplicationHelper

  before_action :logged_in?

  # For registered users
  # get user_id from session[:user].id
  # get cart_token if cart_state: "processing"
  # For unregistered users return :unauthorized

  def edit; end

  def guest_order
    cart_token = session[:cart_token]
    raise ActiveRecord::RecordNotFound unless cart_token.present?
    raise ::Unauthorized unless cart_token == params[:token]

    guest_cart_items = HashWithIndifferentAccess.new session[cart_token]
    p 'sadsadasdas'
    p guest_cart_items

    raise ActiveRecord::RecordNotFound unless guest_cart_items.present?

    @product_item = ProductItem.includes(:product).find_by!(id: guest_cart_items[:item_id])
    @product = @product_item.product
    @form = GuestOrderBuilderForm.new
    @form.order_item_builder = guest_cart_items.slice(:item_id, :size, :quantity)

    @shipping = 0
    @discount = 0
    @total_amount = @product.price.to_i * guest_cart_items[:quantity].to_i

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

  def update; end

  def destroy
    @cart.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private

  def cart_token
    raise ::Unauthorized unless session[:cart_token].present?

    session[:cart_token]
  end

  def cart_items
    p "cart token .... #{cart_token}"

    @cart_items ||= Cart.joins(:product_items).where(
      cart_token:,
      cart_state: 'processing',
      user_id: current_user.user_id
    ).where('cart.product_item_id = product_items.id')
  end

  def cart_params
    params.fetch(:cart, {})
  end
end
