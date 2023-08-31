require 'mini_magick'

namespace :thumbnails do
  desc 'Generate thumbnails for images'

  task generate: :environment do
    designs_dir = ENV['designs_dir'] || Rails.root.join('app', 'assets', 'images', 'mockups')

    thumbnails_dir = Rails.root.join(designs_dir, 'thumbs')

    Dir.glob(File.join(designs_dir, '*.png')).each do |image_path|
      image = MiniMagick::Image.open(image_path)

      image.resize '500x400!'
      image.format 'png'
      image.quality 80

      thumb_path = File.join(thumbnails_dir, File.basename(image_path))
      p thumb_path

      image.write(thumb_path)
    end

    puts 'Thumbnails generated successfully!'
  end
end

namespace :highres do
  task generate: :environment do
    designs_dir = ENV['designs_dir'] || Rails.root.join('app', 'assets', 'images', 'mockups')

    thumbnails_dir = Rails.root.join(designs_dir, 'high')

    Dir.glob(File.join(designs_dir, '*.png')).each do |image_path|
      image = MiniMagick::Image.open(image_path)

      image.resize '1920x1536!'
      image.quality 100
      image.format 'webp'

      out_path = File.join(thumbnails_dir, File.basename(image_path, '.png') + '.webp')
      p out_path

      image.write(out_path)
    end

    puts 'High Res images generated successfully'
  end
end
