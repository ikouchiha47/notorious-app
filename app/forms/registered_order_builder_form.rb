class RegisteredOrderBuilderForm
  include ActiveModel::Model

  attr_accessor (
    :success,
    :items,
    :address_id,
    :user
  )

  valdiates :address_id, presence: true
  validate :all_items_valid?

  def initialize(attributes = {})
    super
  end

  def items_attributes=(items_params)
    @items ||= []
    items_params.each do |_, item_param|
      @items.push(OrderItemBuilderForm.new(item_param))
    end
  end


  private

  def all_items_valid?
    items.each do |item|
      next if item.valid?
      item.errors.full_messages.each do |full_message|
        self.errors.add(:base, "Product was invalid: #{full_message}")
      end
    end

    throw(:abort) if errors.any?
  end
end
