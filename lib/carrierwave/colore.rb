# frozen_string_literal: true

require 'carrierwave'
require 'carrierwave/colore/version'
require 'carrierwave/storage/colore'

CarrierWave::Storage.autoload :Colore, 'carrierwave/storage/colore'

module CarrierWave
  module Uploader
    class Base
      add_config :colore_config

      configure do |config|
        config.storage_engines[:colore] = 'CarrierWave::Storage::Colore'
        config.cache_storage = :file
      end
    end
  end
end
