# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CarrierWave::Uploader::Base do
  let(:uploader) { described_class }

  it 'inserts Colore as a known storage engine' do
    uploader.configure do |config|
      expect(config.storage_engines).to have_key(:colore)
    end
  end

  it 'sets cache storage to file' do
    uploader.configure do |config|
      expect(config.cache_storage).to eq CarrierWave::Storage::File
    end
  end
end
