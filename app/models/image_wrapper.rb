class ImageWrapper
  include ActiveModel::Model

  attr_accessor :images, :high_format, :thumb_format

  validate :non_empty

  def initialize(root_path:)
    @root_path = root_path
    @images = []
    @thumb_format = 'png'
    @high_format = 'webp'
  end

  def thumb(file_name)
    file_name = File.basename(file_name, File.extname(file_name))
    "#{@root_path}/thumbs/#{file_name}.#{@thumb_format}"
  end

  def base(file_name)
    "#{@root_path}/#{file_name}"
  end

  def high(file_name)
    file_name = File.basename(file_name, File.extname(file_name))
    "#{@root_path}/high/#{file_name}.#{@high_format}"
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
