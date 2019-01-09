# frozen_string_literal: true

module Auth0
  module Verifier
    module Handlers
      class Base
        attr_reader :token, :config

        def initialize(token:, config:)
          @token = token
          @config = config
        end
      end
    end
  end
end
