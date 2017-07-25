require 'carrierwave'

if Settings.s3.upload_bucket
  CarrierWave.configure do |config|
    # config.fog_provider = 'fog/aws' # we use carrierwave-aws instead of fog now
    # config.fog_credentials = {
    #   provider: 'AWS',
    #   use_iam_profile: true
    # }
    config.storage = :aws
    config.aws_bucket = Settings.s3.upload_bucket
    config.aws_acl = 'bucket-owner-full-control'
  end
end
