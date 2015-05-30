# encoding: utf-8
require "google_drive"
require "open-uri"
require "rubygems"
require "google/api_client"

module CarrierWave
  module Storage

    class GoogleDrive < Abstract

      def connection
        client = Google::APIClient.new
        auth = client.authorization
        # Follow "Create a client ID and client secret" in
        # https://developers.google.com/drive/web/auth/web-server] to get a client ID and client secret.
        auth.client_id = uploader.client_ID             #"YOUR CLIENT ID"
        auth.client_secret = uploader.client_secret     #"YOUR CLIENT SECRET"
        auth.scope =
            "https://www.googleapis.com/auth/drive " +
            "https://spreadsheets.google.com/feeds/"
        auth.redirect_uri = uploader.client_secret      #"http://example.com/redirect"
        # auth.refresh_token = refresh_token
        # auth.grant_type = 'refresh_token'
        auth.fetch_access_token!
        @connection ||= ::GoogleDrive.login_with_oauth(auth.access_token)
        
        # @connection ||= ::GoogleDrive.login( uploader.google_login, uploader.google_password )
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

        def read
          open(url).read
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
