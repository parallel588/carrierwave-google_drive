# Carrierwave::GoogleDrive

This gem adds storage support for Google Drive to CarrierWave

## Installation

Add this line to your application's Gemfile:

    gem 'carrierwave-google_drive'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install carrierwave-google_drive

## Usage
Note that for your uploader, your should extend the CarrierWave::Uploader::GoogleDrive class.

```ruby
class DocumentUploader < CarrierWave::Uploader::GoogleDrive

  google_login    'google_account@gmail.com'
  google_password 'password'

    
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
