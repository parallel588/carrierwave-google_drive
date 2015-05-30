require "carrierwave-google_drive/version"
require "carrierwave/storage/google_drive"

module Carrierwave
  module GoogleDrive
    # Your code goes here...
  end
end

CarrierWave::Uploader::Base.add_config :google_login
CarrierWave::Uploader::Base.add_config :google_password
CarrierWave::Uploader::Base.add_config :client_ID
CarrierWave::Uploader::Base.add_config :client_secret
CarrierWave::Uploader::Base.add_config :redirect_URIs

CarrierWave.configure do |config|
  config.storage_engines.merge!({:google_drive => "CarrierWave::Storage::GoogleDrive"})
end


require "carrierwave/uploader/google_drive"
