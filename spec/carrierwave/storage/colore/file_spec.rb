# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CarrierWave::Storage::Colore::File do
  subject(:colore_file) do
    described_class.new(uploader, connection, path)
  end

  let(:path)       { 'files/1/file.txt' }
  let(:file)       { double(:file, content_type: 'octet', path: '/file') }
  let(:bucket)     { double(:bucket, object: file) }
  let(:connection) { double(:connection, bucket: bucket) }

  let(:colore_config) do
    {
      base_uri: 'http://localhost:9200',
      app: 'colore-carrierwave'
    }
  end

  let(:uploader) { double('CarrierWave', colore_config: colore_config, create_document: file) } # rubocop:disable RSpec/VerifiedDoubles

  describe '#read' do
    let(:colore_object) { instance_double('RestClient::Response') }

    it 'reads the retrieved body if called without block' do
      colore_file.file = colore_object

      expect(colore_object).to receive_message_chain('get.body.read')
      colore_file.read
    end

    it 'does not retrieve body if block given' do
      colore_file.file = colore_object
      block = proc {}

      expect(colore_object).to receive('get')
      expect(colore_file.read(&block)).to be_nil
    end
  end

  describe '#store' do
    context 'when new_file is a Colore File' do
      let(:new_file) do
        described_class.new(uploader, connection, path)
      end

      it 'moves the object' do
        expect(new_file).to receive(:move_to).with(path)
        colore_file.store(new_file)
      end
    end

    context 'when new file if a SanitizedFile' do
      let(:new_file) do
        CarrierWave::SanitizedFile.new('spec/fixtures/file.txt')
      end

      it 'uploads the file using with multipart support' do
        expect(file).to(receive(:upload_file)
                              .with(new_file.path, an_instance_of(Hash)))
        colore_file.store(new_file)
      end
    end
  end
end
