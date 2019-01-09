# frozen_string_literal: true

require 'uri'

module Auth0
  module Verifier
    class Configuration
      attr_writer :domain, :audience, :jwks_url, :type

      def url
        "https://#{domain}"
      end

      def domain
        @domain || URI(ENV['AUTH0_DOMAIN']).host
      end

      def type
        @type || :RS256
      end

      def audience
        @audience || ENV['AUTH0_AUDIENCE']
      end

      def jwks_url
        return @jwks_url if @jwks_url
        return unless domain

        "#{url}/.well-known/jwks.json"
      end
    end
  end
end
