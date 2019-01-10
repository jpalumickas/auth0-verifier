# frozen_string_literal: true

require 'uri'

module Auth0
  module Verifier
    # Configuration file
    class Configuration
      attr_writer :domain, :audience, :jwks_url, :type, :use_ssl, :cache

      def url
        protocol = use_ssl ? 'https' : 'http'
        "#{protocol}://#{domain}"
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

      def use_ssl
        return @use_ssl unless @use_ssl.nil?

        true
      end

      def jwks_url
        return @jwks_url unless @jwks_url.nil?
        return unless domain

        "#{url}/.well-known/jwks.json"
      end

      def cache
        return redis_cache if @cache == :redis
        return @cache unless @cache.nil?

        null_cache
      end

      private

      def null_cache
        @null_cache ||= Auth0::Verifier::Cache::Null.new
      end

      def redis_cache
        @redis_cache ||= Auth0::Verifier::Cache::Redis.new
      end
    end
  end
end
