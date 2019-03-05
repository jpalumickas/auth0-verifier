# frozen_string_literal: true

require 'uri'

module Auth0
  module Verifier
    # Configuration file
    class Configuration
      attr_writer :domain, :audience, :jwks_url, :type, :use_ssl

      def url
        protocol = use_ssl ? 'https' : 'http'
        "#{protocol}://#{domain}"
      end

      def domain
        (@domain || ENV['AUTH0_DOMAIN']).gsub(%r{\Ahttps?://}, '')
      end

      def type
        @type || :RS256
      end

      def audience
        @audience || ENV['AUTH0_AUDIENCE']
      end

      def use_ssl
        return @use_ssl unless @use_ssl.nil?

        true
      end

      def jwks_url
        return @jwks_url if @jwks_url
        return unless domain

        "#{url}/.well-known/jwks.json"
      end
    end
  end
end
