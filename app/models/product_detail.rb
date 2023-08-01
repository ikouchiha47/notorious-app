# Get the product detail with usable garment info
class ProductDetail
  DEFAULT_MEASUREMENT_UNIT = "inch"

  attr_reader :product

  def initialize(product_id, product = nil)
    @product_id = product_id
    @product = product.nil? ? build_product : product
  end

  def get
    return if @product.nil?

    details = @product.product_item.details
    size_details = details["details"]

    measure_unit = get_measurement(details["measure_unit"])
    style = details["style"]
    style = Product::GARMENT_TYPES[style]

    sizes = size_details["sizes"] || []
    shoulder_sizes = size_details["shoulder_sizes"] || []
    chest_sizes = size_details["chest_sizes"] || []

    waist_sizes = details["waist_sizes"] || []
    taper_angles = details["taper_angles"] || []

    item_id = @product.product_item.id

    if @product.pants?
      ::Apparels::Panties.new(
        item_id:,
        style:,
        measure_unit:,
        colors: size_details["colors"] || ["black"],
        sizes:,
        waist_sizes:,
        taper_angles:
      )
    else
      ::Apparels::Tshirt.new(
        item_id:,
        style:,
        measure_unit:,
        colors: size_details["colors"] || ["black"],
        sizes:,
        shoulder_sizes:,
        chest_sizes:
      )
    end
  end

  private

  def build_product
    Product
    .includes(:product_item, :category)
    .where(products: { id: @product_id })
    .first
  end

  def get_measurement(measured_unit)
    measured_unit.present? ? measured_unit : DEFAULT_MEASUREMENT_UNIT
  end


end
