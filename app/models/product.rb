class Product < ApplicationRecord # :nodoc:
  include Uidable

  GARMENT_TYPES = {
    "#{::GarmentTypes::OVER_TEE}" => 'Oversized Tees',
    "#{::GarmentTypes::REGULAR_TEE}" => 'Regular Tees',
    "#{::GarmentTypes::PANTIES}" => 'Baggy Tracks'
  }

  has_one :product_item
  belongs_to :category

  before_validation :set_sku_provider, :set_gender

  validates :sku, presence: true, length: { in: 5..100 }
  validates :sku_provider, presence: true
  validates :title, presence: true
  validates :gender, presence: true, inclusion: %w[unisex male female]
  # validates :description

  # in paisa or cents or lowest denomination
  validates :price, numericality: { only_integer: true }
  validates :images, presence: true
  validates :available, inclusion: [true, false]
  validates :is_limited_edition, inclusion: [true, false]

  validates :category_id, presence: true

  # created_at, #updated_at

  def promoted_image
    splits = images.split(',')
    return 'https://placehold.co/400x400,https://placehold.co/400x400' unless splits.present?

    splits[0]
  end

  def product_images
    images.split(',')
  end

  def oversized_tee?
    product_type == ::GarmentTypes::OVER_TEE
  end

  def regular_tee?
    product_type == ::GarmentTypes::REGULAR_TEE
  end

  def pants?
    product_type == ::GarmentTypes::PANTIES
  end

  def self.available
    where({ available: true }).order('created_at ASC')
  end

  def self.featured
    available.order('updated_at DESC').limit(6)
  end

  private

  def set_sku_provider
    self.sku_provider = 'default' unless sku_provider.present?
  end

  def set_gender
    self.gender = 'unisex' unless gender.present?
  end
end
