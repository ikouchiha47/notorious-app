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

  10.times do |i|
    # images = 'mockups/chemical_x_black_flat.png'
    imager = ImageWrapper.new(root_path: 'mockups')

    imager.images << 'chemical_x_black_flat.png'
    imager.images << 'chemical_x_black_flat.png'
    title = 'Chemical X'

    if (i % 3).zero?
      imager.images = ['chemical_x_white_man.png']
      imager.images << 'chemical_x_white_man.png'

      title = 'Brains of family'
    elsif (i % 5).zero?
      imager.images = ['chemical_x_black_man.png']
      imager.images << 'chemical_x_black_man.png'

      title = 'Sawadika'
    end

    raise imager.errors.full_messages unless imager.valid?

    Product.create!({
                      sku:,
                      sku_provider:,
                      title:,
                      price: 1200 * 100,
                      images: imager.to_s,
                      available: true,
                      gender: 'unisex',
                      category_id:,
                      product_type: 'regular::tee'
                    })
  end

  10.times do |i|
    imager = ImageWrapper.new(root_path: 'mockups')

    imager.images << 'chemical_x_black_flat.png'
    imager.images << 'chemical_x_black_flat.png'

    title = 'Chemical X'

    if (i % 3).zero?
      imager.images = ['chemical_x_black_man.png']
      imager.images << 'chemical_x_black_man.png'

      title = 'Pizza senses'
    elsif (i % 5).zero?
      imager.images = ['chemical_x_white_man.png']
      imager.images << 'chemical_x_white_man.png'
      title = 'Graphic'
    end

    raise imager.errors.full_messages unless imager.valid?

    Product.create!({
                      sku:,
                      sku_provider:,
                      title:,
                      price: 1497 * 100,
                      images: imager.to_s,
                      available: true,
                      gender: 'unisex',
                      category_id:,
                      product_type: 'over::tee'
                    })
  end
end

def create_each(product, style)
  ProductItem.create!({ id: ULID.generate, product_id: product.id, details: style })
end

def build_items
  products = Product.take(9)
  over_tshirt = {
    "style": 'over::tee',
    "details": {
      "dimensions": [[20, 27, 17], [21, 28, 18], [22, 29, 18.5]],
      "sizes": %w[M L XL],
      "colors": %w[blue black green]
    }
  }
  tshirt = {
    "style": 'regular::tee',
    "details": {
      "dimensions": [[20, 27, 17], [21, 28, 18], [22, 29, 18.5]],
      "sizes": %w[M L XL],
      "colors": %w[blue black green]
    }
  }

  panties = {
    "style": 'panties',
    "details": {
      "dimensions": [[30, 39, 2], [32, 40, 2], [34, 41, 2]],
      "sizes": %w[M L XL],
      "colors": %w[blue black green]
    }
  }

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

def create_guest_user
  User.first_or_create!(
    password: 'ikea',
    country_code: 0, number: 1_234_560,
    verified: false, email: 'vindy.ssa@mailinator.com'
  )
end

# create_guest_user

# build_categories
build_products

build_items
