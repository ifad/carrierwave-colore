module CarrierWave
  module Storage
    class Colore < Abstract
      class << self
        def connection_cache
          @connection_cache ||= {}
        end
      end

      def connection
        @connection ||= begin
          options = uploader.colore_config
          self.class.connection_cache[options] ||= ::Colore::Client.new(options)
        end
      end

      # Store a file in Colore.
      #
      # @param  file [CarrierWave::SanitizedFile]
      # @return [CarrierWave::Storage::Colore::File] stored file
      def store!(file)
        f = CarrierWave::Storage::Colore::File.new(connection, uploader.store_path)
        f.store(file)
        f
      end

      # Retrieve a file from Colore.
      #
      # @param filename [String]
      # @return [CarrierWave::Storage::Colore::File] retrieved file
      def retrieve!(filename)
        CarrierWave::Storage::Colore::File.new(connection, uploader.store_path, filename)
      end

      class File
        # @param connection [Colore::Client]
        # @param store_path [String] Colore `doc_id`
        # @param filename   [String] Colore `filename` (defaults to nil, e.g.
        #   for a new document)
        # @param version    [String] Colore `version` (defaults to `current`)
        def initialize(connection, store_path, filename = nil, version = 'current')
          @connection = connection
          @store_path = store_path
          @filename   = filename
          @version    = version
        end

        # Duck-type methods for CarrierWave::SanitizedFile
        def content_type ; end
        def url          ; end
        def size         ; end
        def delete       ; end

        # Returns whether a version exists in Colore.
        #
        # @return boolean
        def exists?
          if @version == 'current'
            version = info["current_version"]
          else
            version = @version
          end

          info["versions"].has_key?(version)
        end

        # Read a file from Colore.
        #
        # @return String
        def read
          file
        end

        # Store a file in Colore.
        #
        # @param  file [CarrierWave::SanitizedFile]
        def store(new_file)
          response = @connection.create_document(
            doc_id:   @store_path,
            filename: new_file.filename,
            content:  new_file.to_file
          )
          @filename = response["path"]
        end

        # Returns a list of versions and formats on Colore.
        #
        # @return array
        def versions
          info["versions"].inject({}) do |hash, (version, format)|
            hash[version] = format.keys; hash
          end
        end

        # Returns a specific version from Colore. If the version doesn't exist
        # an error won't be returned until you try to read the file.
        #
        # @return [CarrierWave::Storage::Colore::File]
        def version(version)
          self.class.new(@connection, @store_path, @filename, version)
        end

        # Returns a specific format from Colore. If the format doesn't exist
        # an error won't be returned until you try to read the file.
        #
        # @return [CarrierWave::Storage::Colore::File]
        def format(format)
          filename = ::File.basename(@filename, ::File.extname(@filename)) + "." + format
          self.class.new(@connection, @store_path, filename, @version)
        end

        # Request a conversion of the file.
        #
        # @param format       String Type to convert to.
        # @param callback_url String Callback URL after conversion is complete
        def convert(format, callback_url = nil)
          options = {
            doc_id:       @store_path,
            version:      @version,
            filename:     @filename,
            action:       format,
            callback_url: callback_url
          }.compact

          @connection.request_conversion(options)
        end

        # Return the Colore URL for this file. This can be used by the client
        # application and the Colore Nginx plugin to serve the file. See
        # https://github.com/ifad/colore/blob/e2fa09b303ae370965c8ca0185c252f0dcecbd3c/nginx/colore.nginx.conf#L53-L65
        #
        # @return String
        def url
          @connection.path_for(@store_path, @version, @filename)
        end

        protected

        def file
          @file ||= begin
            @connection.get_document(
              doc_id:   @store_path,
              version:  @version,
              filename: @filename
            )
          end
        end

        def info
          @info ||= begin
            @connection.get_document_info(
              doc_id:   @store_path
            )
          end
        end
      end
    end
  end
end
