# frozen_string_literal: true

RSpec.describe Auth0::Verifier::Configuration do
  let(:config) { described_class.new }

  describe '#domain' do
    it 'returns correct domain when only host set' do
      config.domain = 'example.com'
      expect(config.domain).to eq('example.com')
    end

    it 'returns correct domain when host with protocol set' do
      config.domain = 'https://example.com'
      expect(config.domain).to eq('example.com')
    end

    context 'with ENV variable' do
      it 'returns correct domain when only host set' do
        allow(ENV).to receive(:[]).with('AUTH0_DOMAIN')
          .and_return('example.com')
        expect(config.domain).to eq('example.com')
      end

      it 'returns correct domain when host with protocol set' do
        allow(ENV).to receive(:[]).with('AUTH0_DOMAIN')
          .and_return('https://example.com')
        expect(config.domain).to eq('example.com')
      end
    end
  end
end
