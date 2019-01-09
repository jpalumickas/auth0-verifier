# frozen_string_literal: true

require_relative 'verifier/version'
require_relative 'verifier/error'
require_relative 'verifier/configuration'
require_relative 'verifier/jwks'
require_relative 'verifier/handler'

module Auth0
  module Verifier
    class << self
      def config
        @config ||= Configuration.new
      end
      alias configuration config

      def configure
        yield(config) if block_given?
        true
      end
    end
  end
end
