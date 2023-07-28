# Defines structs for different GarmentTypes


module Apparels
  DEFAULT_MEASUREMENT_UNIT = "inch"

  Tshirt = Struct.new(:style, :colors, :sizes, :shoulder_sizes, :chest_sizes) do
    def size_chart
      sizes
        .zip(shoulder_sizes, chest_sizes).map do |size, shoulder_size, chest_size|
          {
            size:,
            shoulder_size:,
            chest_size:,
            measured: get_measurement(data["measured"])
          }
        end
    end
  end

  Panties = Struct.new(:style, :colors, :sizes, :waist_sizes, :taper_angles) do
    def size_chart
      sizes
        .zip(waist_sizes, taper_angles).map do |size, waist_size, taper_angle|
          {
            size:,
            waist_size:,
            taper_angle:,
            measured: get_measurement(data["measured"])
          }
        end
    end
  end

  def get_measuremet(measured_unit)
    measured_unit.present? ? measured_unit : DEFAULT_MEASUREMENT_UNIT
  end


end
