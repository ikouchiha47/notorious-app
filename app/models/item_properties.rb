class ItemProperties
  SEPERATOR = ';;'.freeze

  attr_accessor :size, :color, :quantity

  def initialize(params)
    params.each { |k, v| public_send("#{k}=", v) }
  end

  def properties
    @properties ||= { size:, color:, quantity: }
  end

  def encode
    properties.each_key.reduce([]) do |acc, key|
      acc << "#{key}:#{properties[key]}"
    end.join(SEPERATOR)
  end

  def self.decode(property_list)
    @properties = ActiveSupport::HashWithIndifferentAccess.new
    property_list.split(SEPERATOR).each do |property|
      key, value = property.split(':')
      @properties[key] = value
    end

    @properties
  end
end
