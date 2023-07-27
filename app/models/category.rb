class Category < ApplicationRecord
  has_many :products, class_name: 'Product', foreign_key: 'category_id'

  validates :name, presence: true, length: { in: 3..50 }

  def slug
    SexySlug.from(name)
  end
end
