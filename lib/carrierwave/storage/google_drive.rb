# encoding: utf-8
require "google_drive"

module CarrierWave
  module Storage

    class GoogleDrive < Abstract

      def connection
        @connection ||= ::GoogleDrive.login( uploader.google_login, uploader.google_password )
      end

      def store!(file)
        f = CarrierWave::Storage::GoogleDrive::File.new(uploader, self)
        f.store(file)
        f
      end

      def retrieve!(resource_id)
        CarrierWave::Storage::GoogleDrive::File.new(uploader, self, resource_id)
      end

      class File

        def initialize(uploader, storage, resource_id = nil)
          @uploader   = uploader
          @storage    = storage
          @version_name = (uploader.version_name||'default').to_sym
          @resource_id = YAML.load(resource_id.to_s)[@version_name] rescue ""
        end

        def store(file)
          @remote_file = connection.upload_from_file(file.path, nil, :convert => false)
          @remote_file.acl.push( {:scope_type => "default", :role => "reader"})
          @resource_id = @remote_file.resource_id.split(':').last
          @uploader.key = @remote_file.resource_id.split(':').last
          @resource_id
        end

        def delete
          if @resource_id.present?
            file.delete
          end
        end

        def connection
          @storage.connection
        end

        def content_type
          @content_type ||= file.available_content_types.first
          @content_type
        end
        def extension
          content_type.to_s
        end

        def url(options = { })
          "https://docs.google.com/uc?&id=#{@resource_id}"
        end

        private
        def file
          @file || begin
                     doc = connection.request(:get, "https://docs.google.com/feeds/default/private/full/#{@resource_id}?v=3", :auth => :writely)
                     @file = connection.entry_element_to_file(doc)
                   end
          @file
        end


      end

    end

  end
end
