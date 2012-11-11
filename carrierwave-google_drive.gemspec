# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'carrierwave-google_drive/version'

Gem::Specification.new do |gem|
  gem.name          = "carrierwave-google_drive"
  gem.version       = Carrierwave::GoogleDrive::VERSION
  gem.authors       = ["Maxim Pechnikov"]
  gem.email         = ["parallel588@gmail.com"]
  gem.description   = %q{This gem provides a simple way to upload files from Rails application to Google Drive service.}
  gem.summary       = %q{Google Drive  storage for CarrierWave gem}
  gem.homepage      = ""

  gem.add_dependency('carrierwave', '>= 0.7.1')
  gem.add_dependency('parallel588_google_drive', '= 0.3.4')
  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec", "~> 2.11.0"
  gem.add_development_dependency('simplecov')
  gem.add_development_dependency('webmock')

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
