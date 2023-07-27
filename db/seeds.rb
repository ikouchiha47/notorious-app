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
    Category.create({ name: name })
  end
end

def build_products
  Product.delete_all

  sku = 'Test_1'
  sku_provider = 'Printify'
  category_id = Category.first.id

  20.times do
    Product.create!({
      sku: sku,
      sku_provider: sku_provider,
      title: 'Chemical X',
      price: 1200,
      images: ['https://placehold.co/400x400', 'https://placehold.co/400x400'].join(','),
      available: true,
      gender: 'unisex',
      category_id: category_id
    })
  end
end

build_categories
build_products
