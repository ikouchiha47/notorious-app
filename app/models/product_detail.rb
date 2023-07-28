# Get the product detail with usable garment info
class ProductDetail
  attr_reader :product

  def initialize(product_id)
    @product_id = product_id
  end

  def get
    @product = Product
               .includes(:product_item, :category)
               .where(products: { id: @product_id })
               .first

    return if @product.nil?

    details = @product.product_item.details
    size_details = details["details"]

    style = details["style"]
    style = Product::GARMENT_TYPES[style]

    sizes = size_details["sizes"] || []
    shoulder_sizes = size_details["shoulder_sizes"] || []
    chest_sizes = size_details["chest_sizes"] || []

    waist_sizes = details["waist_sizes"] || []
    taper_angles = details["taper_angles"] || []

    if @product.pants?
      ::Apparels::Panties.new(
        style:,
        colors: details["colors"],
        sizes:,
        waist_sizes:,
        taper_angles:
      )
    else
      ::Apparels::Tshirt.new(
        style:,
        colors: details["colors"],
        sizes:,
        shoulder_sizes:,
        chest_sizes:
      )
    end
  end
end
