class HomeController < ApplicationController
  def index
    @featured = Product.featured
  end
end
