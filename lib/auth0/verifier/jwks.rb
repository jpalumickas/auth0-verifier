# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'
require 'base64'
require 'openssl'

module Auth0
  module Verifier
    class Jwks
      attr_reader :url

      def initialize(url)
        @url = url
      end

      def hash
        return unless data

        jwks_keys = Array(data['keys'])
        jwks_keys.each_with_object({}) do |key, object|
          next unless key['alg'] == 'RS256'

          object[key['kid']] = key_certificate(key)
        end
      end

      private

      def key_certificate(key)
        decoded = Base64.decode64(key['x5c'][0])
        OpenSSL::X509::Certificate.new(decoded).public_key
      end

      def data
        @data ||= begin
          result = Net::HTTP.get(URI(url))
          JSON.parse(result)
        end
      end
    end
  end
end
