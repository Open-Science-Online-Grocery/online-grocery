# the file name starts with `01_` to ensure this initializer is run first;
# other initializers may depend upon APP_CONFIG being loaded.
APP_CONFIG = YAML.load(
  ERB.new(
    File.read("#{Rails.root}/config/app_config.yml.erb")
  ).result,
  aliases: true
)[Rails.env].with_indifferent_access
