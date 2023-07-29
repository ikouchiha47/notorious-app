class CartsController < ApplicationController
  # before_action :set_cart , only: %i[ show edit update destroy ]

  def index
    @carts = Cart.all
  end

  def show
  end

  def edit
  end

  def create
    p params
    # @cart = Cart.new(cart_params)

    total_items = 5
    respond_to do |format|

      format.json { render json: {cart_token: cart_key, total_items:}}
      # if @cart.save
      # else
      #   format.json { render json: @cart.errors, status: :unprocessable_entity }
      # end
    end
  end

  # PATCH/PUT /carts/1 or /carts/1.json
  def update

  end

  # DELETE /carts/1 or /carts/1.json
  def destroy
    @cart.destroy

    respond_to do |format|
      format.html { redirect_to carts_url, notice: "Cart was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    def set_cart
      @cart = Cart.find(params[:id])
    end

    def cart_key
      @cart_key ||= SecureRandom.hex(8)
    end

    # Only allow a list of trusted parameters through.
    def cart_params
      params.fetch(:cart, {})
    end
end
