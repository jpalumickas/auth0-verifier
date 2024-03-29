# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Auth0::Verifier::Handlers::Rs256 do
  let(:verifier) { described_class.new(token: token, config: config) }

  let(:audience) { 'test-audience' }
  let(:domain) { 'example.com' }
  let(:config) do
    config = Auth0::Verifier::Configuration.new
    config.audience = audience
    config.domain = domain
    config
  end

  let(:private_key) do
    OpenSSL::PKey::RSA.generate(2048)
  end

  let(:public_key) do
    private_key.public_key
  end

  let(:certificate) do
    cert_subject = '/C=LT/O=Test/OU=Test/CN=Test'

    cert = OpenSSL::X509::Certificate.new
    cert.subject = cert.issuer = OpenSSL::X509::Name.parse(cert_subject)
    cert.not_before = Time.now
    cert.not_after = Time.now + (365 * 24 * 60 * 60)
    cert.public_key = public_key
    cert.serial = 0x0
    cert.version = 2

    ef = OpenSSL::X509::ExtensionFactory.new
    ef.subject_certificate = cert
    ef.issuer_certificate = cert
    cert.extensions = [
      ef.create_extension('basicConstraints', 'CA:TRUE', true),
      ef.create_extension('subjectKeyIdentifier', 'hash')
    ]
    cert.add_extension(
      ef.create_extension(
        'authorityKeyIdentifier',
        'keyid:always,issuer:always'
      )
    )

    cert.sign private_key, OpenSSL::Digest.new('SHA1')

    cert.to_pem
  end

  let(:x5c) do
    certificate.to_s
      .gsub('-----BEGIN CERTIFICATE-----', '')
      .gsub('-----END CERTIFICATE-----', '')
      .split("\n").map(&:strip).join
  end

  let(:jwks_data) do
    {
      'keys' => [
        {
          'alg' => 'RS256',
          'kty' => 'RSA',
          'use' => 'sig',
          'x5c' => [
            x5c
          ],
          'kid' => 123
        }
      ]
    }
  end
  let(:token) do
    JWT.encode(
      {
        kid: 123,
        sub: 'john',
        aud: audience,
        iss: "https://#{domain}/"
      },
      private_key,
      'RS256',
      kid: 123
    )
  end

  before do
    stub_request(:get, "https://#{domain}/.well-known/jwks.json").to_return(
      status: 200,
      body: jwks_data.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )
  end

  context 'with valid token' do
    let(:return_data) do
      {
        'kid' => 123,
        'sub' => 'john',
        'aud' => audience,
        'iss' => "https://#{domain}/"
      }
    end

    let(:return_headers) do
      { 'alg' => 'RS256', 'kid' => 123 }
    end

    it 'returns correct data' do
      expect(verifier.verify).to eq([return_data, return_headers])
    end
  end

  context 'with invalid token' do
    let(:token) { 'test' }

    it 'raises an error' do
      expect { verifier.verify }.to raise_error(Auth0::Verifier::Error)
    end
  end

  context 'with invalid audience' do
    let(:config) do
      config = Auth0::Verifier::Configuration.new
      config.audience = 'bad'
      config.domain = domain
      config
    end

    it 'raises an error' do
      expect { verifier.verify }.to raise_error(Auth0::Verifier::Error)
    end
  end

  context 'with invalid domain' do
    let(:config) do
      config = Auth0::Verifier::Configuration.new
      config.audience = audience
      config.domain = 'example2.com'
      config.jwks_url = "https://#{domain}/.well-known/jwks.json"
      config
    end

    it 'raises an error' do
      expect { verifier.verify }.to raise_error(Auth0::Verifier::Error)
    end
  end
end
