# frozen_string_literal: true

require_relative 'handlers/base'
require_relative 'handlers/rs256'

module Auth0
  module Verifier
    class Handler
      def initialize(options = {})
        options.each do |key, value|
          config.public_send("#{key}=", value) if config.respond_to?("#{key}=")
        end
      end

      def verify(token)
        handler.new(token: token, config: config).verify
      end

      def config
        @config ||= Auth0::Verifier::Configuration.new
      end
      alias configuration config

      def configure
        yield(config) if block_given?
        true
      end

      private

      def handler
        case config.type.to_s.downcase
        when 'rs256'
          Auth0::Verifier::Handlers::Rs256
        else
          raise NotImplementedError
        end
      end
    end
  end
end
