# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CarrierWave::Storage::Colore do
  subject(:storage) do
    described_class.new(uploader)
  end

  let(:colore_config) do
    {
      base_uri: 'http://localhost:9200',
      app: 'colore-carrierwave'
    }
  end

  let(:uploader) { double('CarrierWave', colore_config: colore_config, store_path: 'path/to/file.txt') } # rubocop:disable RSpec/VerifiedDoubles

  before do
    described_class.clear_connection_cache!
  end

  describe '#connection' do
    before do
      allow(Colore::Client).to receive(:new).and_return true
    end

    it 'instantiates a new connection' do
      storage.connection

      expect(Colore::Client).to have_received(:new).with(colore_config)
    end

    it 'caches connections by credentials' do
      new_storage = described_class.new(uploader)

      expect(storage.connection).to be(new_storage.connection)
    end
  end

  describe '#store!' do
    subject(:store!) { storage.store! file }

    let(:file) { instance_double('CarrierWave::SanitizedFile') }
    let(:colore_file) { instance_double('CarrierWave::Storage::Colore::File', store: true) }

    before do
      allow(CarrierWave::Storage::Colore::File).to receive(:new).and_return(colore_file)
    end

    it 'stores the file in Colore' do
      store!

      expect(CarrierWave::Storage::Colore::File).to have_received(:new).with(storage.connection, uploader.store_path)
    end
  end

  describe '#retrieve!' do
    subject(:retrieve!) { storage.retrieve! 'file.txt' }

    let(:colore_file) { instance_double('CarrierWave::Storage::Colore::File') }

    before do
      allow(CarrierWave::Storage::Colore::File).to receive(:new).and_return(colore_file)
    end

    it 'retrieves the file from Colore' do
      retrieve!

      expect(CarrierWave::Storage::Colore::File).to have_received(:new).with(storage.connection, uploader.store_path, 'file.txt')
    end
  end

  describe '#delete_dir!' do
    subject { storage.delete_dir! 'path' }

    it { is_expected.to be nil }
  end
end
