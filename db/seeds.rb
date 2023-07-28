# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

def build_categories
  Category.delete_all

  %w[minimal graphic].each do |name|
    Category.create({ name: })
  end
end

def build_products
  ProductItem.delete_all
  Product.delete_all

  sku = 'Test_1'
  sku_provider = 'Printify'
  category_id = Category.first.id

  10.times do
    Product.create!({
      sku:,
      sku_provider:,
      title: 'Chemical X',
      price: 1200 * 100,
      images: ['https://placehold.co/400x400', 'https://placehold.co/400x400'].join(','),
      available: true,
      gender: 'unisex',
      category_id:,
      product_type: 'regular::tee'
    })
  end

  10.times do
    Product.create!({
      sku:,
      sku_provider:,
      title: 'Chemical X',
      price: 1497 * 100,
      images: ['https://placehold.co/400x400', 'https://placehold.co/400x400'].join(','),
      available: true,
      gender: 'unisex',
      category_id:,
      product_type: 'over::tee'
    })
  end
end

def build_items
  products = Product.take(9)

  over_tshirt = {
    "style": 'oversized',
    "details": {
      "shoulder_sizes": [18, 19, 20],
      "chest_sizes": [40, 42, 44],
      "sizes": %w[M L XL],
      "colors": ['blue']
    }
  }
  tshirt = {
    "style": 'regular',
    "details": {
      "shoulder_sizes": [18, 19, 20],
      "chest_sizes": [40, 42, 44],
      "sizes": %w[M L XL],
      "colors": ['blue']

    }
  }

  panties = {
    "style": 'regular',
    "details": {
      "waist_sizes": [32, 34, 36, 40],
      "taper_angle": 2,
      "sizes": %w[M L XL XXL],
      "colors": ['blue']
    }
  }

  def create_each(product, style)
    ProductItem.create!({ id: ULID.generate, product_id: product.id, details: style })
  end

  3.times do |i|
    create_each(products[i], over_tshirt)
  end

  (3..5).each do |i|
    create_each(products[i], tshirt)
  end

  (6..8).each do |i|
    create_each(products[i], panties)
  end
end

build_categories
build_products

build_items
