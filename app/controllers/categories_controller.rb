class CategoriesController < ApplicationController
  before_action :set_category, only: :show

  def index
    add_breadcrumb("Products", products_url)

    @categories = Category.all
    @products = Product.available.where(category_id: @categories.pluck(:id))
  end

  def show; end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def category_params
      params.fetch(:category, {})
    end
end
