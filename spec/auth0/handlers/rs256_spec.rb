# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Auth0::Verifier::Handlers::Rs256 do
  subject { described_class.new(token: token, config: config) }

  let(:config) do
    config = Auth0::Verifier::Configuration.new
    config.audience = 'test-audience'
    config.domain = 'example.com'
    config
  end

  let(:public_key) do
    "
    -----BEGIN CERTIFICATE-----
    MIICsDCCAhmgAwIBAgIJAP0uzO56NPNDMA0GCSqGSIb3DQEBBQUAMEUxCzAJBgNV
    BAYTAkFVMRMwEQYDVQQIEwpTb21lLVN0YXRlMSEwHwYDVQQKExhJbnRlcm5ldCBX
    aWRnaXRzIFB0eSBMdGQwHhcNMTYwODAyMTIyMjMyWhcNMTYwOTAxMTIyMjMyWjBF
    MQswCQYDVQQGEwJBVTETMBEGA1UECBMKU29tZS1TdGF0ZTEhMB8GA1UEChMYSW50
    ZXJuZXQgV2lkZ2l0cyBQdHkgTHRkMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKB
    gQDdlatRjRjogo3WojgGHFHYLugdUWAY9iR3fy4arWNA1KoS8kVw33cJibXr8bvw
    UAUparCwlvdbH6dvEOfou0/gCFQsHUfQrSDv+MuSUMAe8jzKE4qW+jK+xQU9a03G
    UnKHkkle+Q0pX/g6jXZ7r1/xAK5Do2kQ+X5xK9cipRgEKwIDAQABo4GnMIGkMB0G
    A1UdDgQWBBR7ZjPnt+i/E8VUy4tinxi0+H5vbTB1BgNVHSMEbjBsgBR7ZjPnt+i/
    E8VUy4tinxi0+H5vbaFJpEcwRTELMAkGA1UEBhMCQVUxEzARBgNVBAgTClNvbWUt
    U3RhdGUxITAfBgNVBAoTGEludGVybmV0IFdpZGdpdHMgUHR5IEx0ZIIJAP0uzO56
    NPNDMAwGA1UdEwQFMAMBAf8wDQYJKoZIhvcNAQEFBQADgYEAnMA5ZAyEQgXrUl6J
    T/JFcg6HGXj9yTy71EEMVp3Md3B8WwDvs+di4JFcq8FKSoGtTY4Pb5WE9QVUAmwE
    sSQoETNYW3quRmYJCkpIHWnvUW/OAf2/Ejr6zXquhBC6WoCeKQuesMvo2qO1rStC
    UWahUh2/RQt9XozEWPWJ9Oe6a7c=
    -----END CERTIFICATE-----
    "
  end
  let(:private_key) do
    "
      -----BEGIN RSA PRIVATE KEY-----
      MIICWwIBAAKBgQDdlatRjRjogo3WojgGHFHYLugdUWAY9iR3fy4arWNA1KoS8kV
      w33cJibXr8bvwUAUparCwlvdbH6dvEOfou0/gCFQsHUfQrSDv+MuSUMAe8jzKE4
      qW+jK+xQU9a03GUnKHkkle+Q0pX/g6jXZ7r1/xAK5Do2kQ+X5xK9cipRgEKwIDA
      QABAoGAD+onAtVye4ic7VR7V50DF9bOnwRwNXrARcDhq9LWNRrRGElESYYTQ6Eb
      atXS3MCyjjX2eMhu/aF5YhXBwkppwxg+EOmXeh+MzL7Zh284OuPbkglAaGhV9bb
      6/5CpuGb1esyPbYW+Ty2PC0GSZfIXkXs76jXAu9TOBvD0ybc2YlkCQQDywg2R/7
      t3Q2OE2+yo382CLJdrlSLVROWKwb4tb2PjhY4XAwV8d1vy0RenxTB+K5Mu57uVS
      THtrMK0GAtFr833AkEA6avx20OHo61Yela/4k5kQDtjEf1N0LfI+BcWZtxsS3jD
      M3i1Hp0KSu5rsCPb8acJo5RO26gGVrfAsDcIXKC+bQJAZZ2XIpsitLyPpuiMOvB
      bzPavd4gY6Z8KWrfYzJoI/Q9FuBo6rKwl4BFoToD7WIUS+hpkagwWiz+6zLoX1d
      bOZwJACmH5fSSjAkLRi54PKJ8TFUeOP15h9sQzydI8zJU+upvDEKZsZc/UhT/Sy
      SDOxQ4G/523Y0sz/OZtSWcol/UMgQJALesy++GdvoIDLfJX5GBQpuFgFenRiRDa
      bxrE9MNUZ2aPFaFp+DyAe+b4nDwuJaW2LURbr8AEZga7oQj0uYxcYw==
      -----END RSA PRIVATE KEY-----
    "
  end

  let(:private_key_object) do
    OpenSSL::PKey::RSA.new(private_key.strip.split("\n").map(&:strip).join("\n"))
  end

  # let(:private_key) do
  #   OpenSSL::PKey::RSA.generate(2048)
  # end
  #
  # let(:public_key) do
  #   private_key.public_key
  # end
  #
  let(:x5c) do
    public_key.to_s
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
    JWT.encode({ kid: 123, sub: 'john', aud: config.audience, iss: 'https://example.com/' }, private_key_object, 'RS256', kid: 123)
  end

  before do
    allow_any_instance_of(Auth0::Verifier::Jwks).to receive(:data).and_return(jwks_data)
  end

  it 'returns correct data' do
    expect(subject.verify).to eq(
      [
        {"kid"=>123, "sub"=>"john", "aud"=>"test-audience", "iss"=>"https://example.com/"},
        {"alg"=>"RS256", "kid"=>123}
      ]
    )
  end
end
