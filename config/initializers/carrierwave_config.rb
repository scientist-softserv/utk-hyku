require 'carrierwave'

if Settings.s3.upload_bucket
  CarrierWave.configure do |config|
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
      provider: 'AWS',
      use_iam_profile: true
    }
    # This must come after fog_credentials due to
    # https://github.com/carrierwaveuploader/carrierwave/pull/1201/files
    config.storage = :fog
    config.fog_directory = Settings.s3.upload_bucket
    config.fog_public = false
  end
end
