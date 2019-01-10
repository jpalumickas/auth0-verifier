# frozen_string_literal: true

require 'jwt'

module Auth0
  module Verifier
    module Handlers
      class Rs256 < Base
        def verify
          decode_jwt do |header|
            jwks.keys[header['kid']]
          end
        rescue JWT::DecodeError, JWT::VerificationError
          if jwks_cache_exists?
            remove_jwks_cache!
            retry
          end

          raise Auth0::Verifier::Error, 'Cannot verify token'
        end

        private

        def decode_jwt(&block)
          JWT.decode(
            token,
            nil,
            true, # Verify the signature of this token
            jwt_options,
            &block
          )
        end

        def jwt_options
          {
            algorithm: 'RS256',
            iss: "#{config.url}/",
            verify_iss: true,
            aud: config.audience,
            verify_aud: true
          }
        end

        def jwks
          @jwks ||= Auth0::Verifier::Jwks
            .new(config.jwks_url, cache: config.cache)
        end

        def jwks_cache_exists?
          config.cache.get(config.jwks_url)
        end

        def remove_jwks_cache!
          config.cache.del(config.jwks_url)
        end
      end
    end
  end
end
