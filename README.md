# CarrierWave Colore

CarrierWave adapter for the [Colore document storage system](https://github.com/ifad/colore).

## Setup

Add to your Gemfile:

    gem 'colore-client',      github: 'ifad/colore-client'
    gem 'carrierwave-colore', github: 'ifad/carrierwave-colore'

And configure CarrierWave, e.g. in `config/initializers/carrierwave.rb`:

    CarrierWave.configure do |config|
      config.storage = :colore
      config.colore_config = {
        base_uri: 'https://my-colore-host/',
        app:      "MyApp",
        logger:   Rails.logger
      }
    end

## Usage

Colore requires a unique identifier for each file uploaded. This should be
defined on your uploader with the `store_path` method.

For example, to use the record id:

    class DocumentUploader < CarrierWave::Uploader::Base
      def store_path
        "#{model.class.name}.#{model.id}"
      end
    end

Or to generate a unique token for each record:

    class DocumentUploader < CarrierWave::Uploader::Base
      def store_path
        token
      end

      process :store_token

      def store_token
        model.token = token
      end

      def token
        @token ||= begin
          model.token || SecureRandom.uuid
        end
      end
    end

Other than that, it just works like a regular CarrierWave adapter.
