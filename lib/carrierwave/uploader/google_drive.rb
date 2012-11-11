require 'carrierwave'

module CarrierWave
  module Uploader
    class GoogleDrive < Base

      attr_accessor :key

      storage :google_drive

      after :store, :updatemodel

      def updatemodel(file)
        model.update_column("#{self.mounted_as}".to_sym, build_version_hash(self.key).to_yaml)
      end

      def build_version_hash(google_reource_id)
        load_version_hash.merge({ (version_name.blank? ? :default : version_name.to_sym) =>  google_reource_id })
      end

      def load_version_hash
        _data = YAML.load(model.read_attribute("#{self.mounted_as}".to_sym))
        _data.is_a?(Hash) ? _data : { }
      rescue
        { }
      end

      private

      def build_versioned_key(key, version_name)
        key
      end

      def store_versions!(new_file)
        active_versions.each { |name, v|
          v.key = build_versioned_key(key, name)
          v.store!(new_file)
        }
      end

      def remove_versions!
        versions.each { |name, v|
          v.key = build_versioned_key(key, name)
          v.remove!
        }
      end

      def retrieve_versions_from_cache!(cache_name)
        versions.each { |name, v|
          v.key = build_versioned_key(key, name)
          v.retrieve_from_cache!(cache_name)
        }
      end

      def retrieve_versions_from_store!(identifier)
        versions.each { |name, v|
          v.retrieve_from_store!(build_versioned_key(identifier, name)) }
      end
    end
  end
end
