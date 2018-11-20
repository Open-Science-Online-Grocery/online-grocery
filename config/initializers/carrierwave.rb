credentials_key = :aws_staging if Rails.env.staging?
credentials_key = :aws_procution if Rails.env.production?

CarrierWave.configure do |config|
  if Rails.env.staging? || Rails.env.production?
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
      provider:              'AWS',
      aws_access_key_id:     Rails.application.credentials.dig(credentials_key, :access_key_id),
      aws_secret_access_key: Rails.application.credentials.dig(credentials_key, :secret_access_key),
    }
    config.fog_directory  = Rails.application.credentials.dig(credentials_key, :bucket)
    config.storage = :fog
  else
    config.storage = :file
  end
end
