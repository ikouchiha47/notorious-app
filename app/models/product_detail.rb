# Get the product detail with usable garment info
class ProductDetail
  DEFAULT_MEASUREMENT_UNIT = 'inch'

  attr_reader :product

  def initialize(product_id, product = nil)
    @product_id = product_id
    @product = product.nil? ? build_product : product
  end

  def get
    return if @product.nil?

    if @product.pants?
      return ::Apparels::Panties.new(
        item_id:,
        style:, measure_unit:,
        colors:, sizes:, dimensions:
      )
    end

    ::Apparels::Tshirt.new(
      item_id:,
      style:, measure_unit:,
      colors:, sizes:, dimensions:
    )
  end

  def details
    @details ||= @product.product_item.details
  end

  def size_details
    @size_details ||= details['details']
  end

  def colors
    size_details['colors'] || ['black']
  end

  def sizes
    size_details['sizes'] || []
  end

  def dimensions
    size_details['dimensions'] || []
  end

  def item_id
    @product.product_item.id
  end

  def measure_unit
    get_measurement(details['measure_unit'])
  end

  def style
    Product::GARMENT_TYPES[details['style']]
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
