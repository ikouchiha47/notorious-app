class ImageWrapper
  include ActiveModel::Model

  attr_accessor :images

  validate :non_empty

  def initialize(root_path:)
    @root_path = root_path
    @images = []
  end

  def thumb(file_name)
    "#{@root_path}/thumbs/#{file_name}"
  end

  def base(file_name)
    "#{@root_path}/#{file_name}"
  end

  def high(file_name)
    "#{@root_path}/high/#{file_name}"
  end

  def first
    @images[0] || nil
  end

  def to_s
    JSON.generate({
                    root_path: @root_path,
                    images: @images
                  })
  end

  def self.from_json(json_str)
    value = JSON.parse(json_str)

    obj = ImageWrapper.new(root_path: value['root_path'])
    obj.images = value['images']
    obj
  rescue StandardError
    nil
  end

  private

  def non_empty
    errors.add(:images, 'Product Images are missing') unless images.present?
  end
end
