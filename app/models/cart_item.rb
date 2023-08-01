# Cart item builder for life
class CartItem
  Item = Struct.new(:item_id, :size, :amount, :link, :quantity, keyword_init: true)

  def initialize(item_ids = [])
    @item_ids = item_ids
  end

  def build
    product_items = ProductItem
      .includes(:product)
      .where(id: map.keys())

    raise ActiveRecord::RecordNotFound unless product_items.present?

    product_items.map do |item|
      Item.new(
        item_id: item.id,
        size: map[item.id],
        amount: item.price,
        link: "/products/#{item.product_id}",
        quantity: 1,
      )
    end

  end

  def map
    @map ||= item_ids.reduce({}) do |acc, current|
      item_id, size = current.split('#')
      acc[item_id] = size
      acc
    end
  end


  def cart_item_params
    item_ids.reduce([]) do |acc, current|
      item_id, size = current.split('#')
      acc << OrderItemBuilderForm.new(item_id: item_id, size: size)
    end
  end
end
