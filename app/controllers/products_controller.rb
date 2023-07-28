class ProductsController < ApplicationController
  before_action :add_products_crumb, only: %i[ show index ]

  def index
    @categories = Category.all
    @products = Product.available.where(category_id: @categories.pluck(:id))
  end

  def show
    # @product_details = ProductItem.where(product_id: @product.id) or not_found

    details = ProductDetail.new(params[:id])
    @product_details = details.get or not_found
    @product = details.product


    add_breadcrumb(@product.title, nil)
  end

  private

  def add_products_crumb
    add_breadcrumb("Products", products_url)
  end

end
