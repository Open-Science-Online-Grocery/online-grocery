# frozen_string_literal: true

module Seeds
  def self.sprout
    require_seed_modules
    load_seeds('Base')
    return unless Rails.env.staging? || Rails.env.development?
    load_seeds('Staging')
    return unless Rails.env.development?
    load_seeds('Development')
  end

  def self.require_seed_modules
    seed_dir = Rails.root.join('db/seeds')
    Dir[seed_dir.join('**/*.rb')].each { |s| require(s) }
  end

  def self.load_seeds(type)
    puts("\n=======  LOADING #{type.upcase} SEEDS")
    seed_from("Seeds::#{type}".safe_constantize)
    puts("\n=======  DONE LOADING #{type.upcase} SEEDS")
  end

  # run all class methods that start with `seed_`, in the order in which they
  # appear in the source file
  def self.seed_from(seed_class)
    seeds = seed_class.methods.map(&:to_s).select do |method|
      method.starts_with?('seed_')
    end
    seeds.sort_by! { |seed| seed_class.method(seed).source_location.last }
    seeds.each do |seed|
      title = seed[4..-1].titleize
      print("Seeding #{title}...\n")
      seed_class.public_send(seed)
      puts("Seeded: #{title} \n ")
    end
  end
end

Seeds.sprout
