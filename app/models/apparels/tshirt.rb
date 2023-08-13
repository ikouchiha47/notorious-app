# Defines structs for different GarmentTypes

module Apparels
  TeeDimension = Struct.new(
    :chest_size,
    :gar_length,
    :shoulder_size,
    keyword_init: true
  )

  Tshirt = Struct.new(
    :item_id,
    :style,
    :colors,
    :measure_unit,
    :sizes,
    :dimensions,
    keyword_init: true
  ) do
    def valid?
      res = dimensions.any? { |dim| dim.length < sizes.length }
      !res
    end

    def size_chart
      sizes
        .zip(dimensions)
        .map do |size, dim|
          dimension = TeeDimension.new(
            chest_size: dim[0],
            gar_length: dim[1],
            shoulder_size: dim[2]
          )

          {
            size:,
            dimension:,
            measured_in: measure_unit,
            template: %w[chest_size gar_length shoulder_size]
          }
        end
    end
  end

  PantyDimension = Struct.new(
    :waist_size,
    :gar_length,
    :taper_angle,
    keyword_init: true
  )

  Panties = Struct.new(
    :item_id,
    :style,
    :colors,
    :measure_unit,
    :sizes,
    :dimensions,
    keyword_init: true
  ) do
    def valid?
      res = dimensions.any? { |dim| dim.length < sizes.length }
      !res
    end

    def size_chart
      sizes
        .zip(dimensions)
        .map do |size, dim|
          dimension = PantyDimension.new(
            waist_size: dim[0],
            gar_length: dim[1],
            taper_angle: dim[2]
          )

          {
            size:,
            dimension:,
            measured_in: measure_unit,
            template: %w[waist_size gar_length taper_angle]
          }
        end
    end
  end
end
