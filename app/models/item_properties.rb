class ItemProperties
  SEPERATOR = ';;'

  def initialize(size:)
    @properties = {size:}
  end

  def encode
    @properties.each_key.reduce([]) do |acc, key|
      acc << "#{key}:#{@properties[key]}"
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
