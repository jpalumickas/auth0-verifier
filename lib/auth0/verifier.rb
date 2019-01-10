# frozen_string_literal: true

require_relative 'verifier/version'
require_relative 'verifier/error'
require_relative 'verifier/configuration'
require_relative 'verifier/jwks'
require_relative 'verifier/handler'

module Auth0
  # Main module for gem
  module Verifier
    class << self
      def handler
        @handler ||= Auth0::Verifier::Handler.new
      end

      def verify!(options = {})
        handler = Auth0::Verifier::Handler.new(options.except(:token))
        handler.verify(options[:token])
      end

      private

      def method_missing(method_name, *args, &block)
        return super unless handler.respond_to?(method_name)

        handler.send(method_name, *args, &block)
      end

      def respond_to_missing?(method_name, include_private = false)
        handler.respond_to?(method_name, include_private)
      end
    end
  end
end
