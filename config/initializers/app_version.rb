version_filename = "#{Rails.root}/config/app_version.yml"
if File.file?(version_filename)
  APP_VERSION = YAML.load_file(version_filename).with_indifferent_access
else
  puts "Warning: application version file is missing. (#{version_filename})"
end
