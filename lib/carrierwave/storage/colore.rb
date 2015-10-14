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
        puts "Store #{file.inspect}"
        f = CarrierWave::Storage::Colore::File.new(connection, uploader.store_path)
        f.store(file)
        f
      end

      # Retrieve a file from Colore.
      #
      # @param filename [String]
      # @return [CarrierWave::Storage::Colore::File] retrieved file
      def retrieve!(filename)
        puts "Retrieve #{identifier.inspect}"
        CarrierWave::Storage::Colore::File.new(connection, uploader.store_path, filename)
      end

      class File
        def initialize(connection, store_path, filename)
          @connection = connection
          @store_path = store_path
          @filename   = filename
          @version    = 'current'
        end

        # Duck-type methods for CarrierWave::SanitizedFile. 
        def content_type ; end
        def url          ; end

        def read
          file.read
        end

        def size         ; end
        def delete       ; end
        def exists?      ; end

        def store(file)
          response = @connection.create_document(
            doc_id:   @store_path,
            filename: file.filename,
            content:  file.to_file
          )
          @path = response["path"]
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
      end
    end
  end
end
