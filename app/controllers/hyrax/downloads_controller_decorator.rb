# frozen_string_literal: true

# OVERRIDE Hyrax 3.5.0 allow downloading directly from S3

require 'aws-sdk-s3'

module Hyrax
  module DownloadsControllerDecorator
    def send_file_contents
      if ENV['S3_DOWNLOADS']
        s3_object = Aws::S3::Object.new(ENV['AWS_BUCKET'], file.digest.first.to_s.gsub('urn:sha1:', ''))
        if s3_object.exists?
          redirect_to s3_object.presigned_url(
            :get,
            expires_in: 3600,
            response_content_disposition: "attachment\; filename=#{file.original_name}"
          )
          return
        end
      end

      # If s3 downloads is off, or if the file isn't in s3.
      super
    end
  end
end

Hyrax::DownloadsController.prepend(Hyrax::DownloadsControllerDecorator)
