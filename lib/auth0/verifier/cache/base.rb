# frozen_string_literal: true

module Auth0
  module Verifier
    module Cache
      class Base
        attr_reader :options

        def initialize(options = {})
          @options = options
        end

        def set(*)
          raise NotImplementedError
        end

        def get(*)
          raise NotImplementedError
        end

        def del(*)
          raise NotImplementedError
        end
      end
    end
  end
end
