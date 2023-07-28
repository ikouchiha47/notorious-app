# Defines structs for different GarmentTypes


module Apparels

  Tshirt = Struct.new(
    :item_id,
    :style,
    :colors,
    :sizes,
    :shoulder_sizes,
    :chest_sizes,
    :measure_unit,
    keyword_init: true
  ) do

    def size_chart
      sizes
        .zip(shoulder_sizes, chest_sizes).map do |size, shoulder_size, chest_size|
          {
            size:,
            measurement: chest_size,
            shoulder_size:,
            chest_size:,
            measured_in: measure_unit
          }
        end
    end
  end

  Panties = Struct.new(
    :item_id,
    :style,
    :colors,
    :sizes,
    :waist_sizes,
    :taper_angles,
    :measure_unit,
    keyword_init: true
  ) do

    def size_chart
      sizes
        .zip(waist_sizes, taper_angles).map do |size, waist_size, taper_angle|
          {
            size:,
            measurement: waist_size,
            waist_size:,
            taper_angle:,
            measured_in: measure_unit
          }
        end
    end
  end
end
