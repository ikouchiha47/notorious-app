class AddressFormBuilder < ApplicationForm
  attr_accessor :address_line_a,
                :address_line_b

  attr_reader :zip_code,
              :country_code,
              :alternate_phone_number,
              :tag

  validates :address_line_a, presence: true, length: { minimum: 10 }

  validates :zip_code, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 10_000,
    less_than_or_equal_to: 9_999_999_999
  }

  validates :alternate_phone_number, length: { in: 6..20 }

  def tag=(value)
    @tag = value || 'Address'
  end

  def zip_code=(value)
    @zip_code = int?(value) ? value.to_i : 0
  end

  def country_code=(value)
    @country_code = int?(value) ? value.to_i : 0
  end

  def alternate_phone_number=(value)
    @alternate_phone_number = if int?(value)
                                value.to_i
                              else
                                0
                              end
  end

  def alternate_number
    "+#{country_code}-#{alternate_phone_number}"
  end

  def self.attributes
    %i[
      address_line_a
      address_line_b
      zip_code
      country_code
      alternate_phone_number
      tag
    ]
  end
end
