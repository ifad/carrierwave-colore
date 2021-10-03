# frozen_string_literal: true

require 'addressable/uri'

module CarrierWave
  module Support
    module UriFilename
      module_function

      def filename(url)
        Addressable::URI.encode_component(url)
      end
    end
  end
end
