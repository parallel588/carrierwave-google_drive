require "carrierwave-google_drive/version"
require "carrierwave/storage/google_drive"

module Carrierwave
  module GoogleDrive
    # Your code goes here...
  end
end

CarrierWave::Uploader::Base.add_config :google_login
CarrierWave::Uploader::Base.add_config :google_password

CarrierWave.configure do |config|
  config.storage_engines.merge!({:google_drive => "CarrierWave::Storage::GoogleDrive"})
end


require "carrierwave/uploader/google_drive"
