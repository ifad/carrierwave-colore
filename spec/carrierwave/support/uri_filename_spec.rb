# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CarrierWave::Support::UriFilename do
  describe '.filename' do
    let(:samples) do
      {
        'documents/app/Lettre+Côte_d_Ivoire' => 'documents/app/Lettre+Co%CC%82te_d_Ivoire'
      }
    end

    it 'encodes a filename as uri' do
      samples.each do |name, uri|
        expect(described_class.filename(name)).to eq(uri)
      end
    end
  end
end
