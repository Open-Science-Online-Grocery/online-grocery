# frozen_string_literal: true

module Seeds
  module Base
    module Labels
      def self.seed_labels
        image_dir = Rails.root.join('db', 'seeds', 'base', 'labels')
        names_to_images = {
          '0 Howe Stars' => '0howestars.png',
          '1 Howe Stars' => '1howestars.png',
          '2 Howe Stars' => '2howestars.png',
          '3 Howe Stars' => '3howestars.png',
          '1 Star' => '1star.png',
          '2 Stars' => '2stars.png',
          '3 Stars' => '3stars.png',
          'Gluten Free' => 'glutenfree.png',
          'Heart Healthy' => 'hearthealthy.png',
          'Low Sodium' => 'lowsodium.png',
          'Organic' => 'organic.png',
          'Unsweetened' => 'unsweetened.png'
        }
        names_to_images.each do |name, image|
          filepath = image_dir.join(image)
          label = Label.find_or_create_by!(name: name, built_in: true)
          label.image.attach(
            io: StringIO.new(File.read(filepath)),
            filename: image,
            content_type: 'image/png'
          )
          sleep(1) # i don't understand why, but things get stuck without this
        end
      end
    end
  end
end
