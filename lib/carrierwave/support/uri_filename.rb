# frozen_string_literal: true

module CarrierWave
  module Support
    module UriFilename
      module_function

      def filename(url)
        URI::DEFAULT_PARSER.escape(url)
      end
    end
  end
end
