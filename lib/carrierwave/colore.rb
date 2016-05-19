require 'colore-client'

module CarrierWave
  module Colore
    VERSION = "0.2.1"
  end
end

CarrierWave::Storage.autoload :Colore, 'carrierwave/storage/colore'

class CarrierWave::Uploader::Base
  add_config :colore_config

  configure do |config|
    config.storage_engines[:colore] = "CarrierWave::Storage::Colore"
  end
end
