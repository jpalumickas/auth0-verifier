# frozen_string_literal: true

require 'digest'

module Auth0
  module Verifier
    module Cache
      class Redis < Base
        def set(value, context = nul)
          redis.set(key(context), value)
        end

        def get(context = nil)
          redis.get(key(context))
        end

        def del(context = nil)
          redis.del(key(context))
        end

        private

        def key(context)
          return base_key unless context

          "#{base_key}-#{Digest::MD5.hexdigest(context.to_s)}"
        end

        def base_key
          options[:key] || 'auth0-verifier'
        end

        def redis
          config.redis || Redis.current
        end
      end
    end
  end
end
