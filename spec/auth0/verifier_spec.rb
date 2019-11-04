# frozen_string_literal: true

RSpec.describe Auth0::Verifier do
  it 'has a version number' do
    expect(Auth0::Verifier::VERSION).not_to be_nil
  end

  describe '.verify!' do
    let(:options) do
      {
        domain: 'example.com'
      }
    end

    it 'raises an error invalid token' do
      expect { described_class.verify!(options.merge(token: 'test')) }
        .to raise_error(Auth0::Verifier::Error)
    end
  end

  describe '.respond_to_missing?' do
    it 'returns truthy value on verify method' do
      expect(described_class).to respond_to(:verify)
    end
  end

  describe '.verify' do
    it 'raises an error invalid token' do
      expect { described_class.verify('test') }
        .to raise_error(Auth0::Verifier::Error)
    end
  end

  describe '.configure' do
    before do
      described_class.configure do |config|
        config.domain = 'https://test'
      end
    end

    it 'has correct api key' do
      expect(described_class.config.domain).to eq('test')
    end
  end
end
