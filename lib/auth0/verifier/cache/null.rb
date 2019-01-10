# frozen_string_literal: true

module Auth0
  module Verifier
    module Cache
      class Null < Base
        def set(*)
        end

        def get(*)
        end

        def del(*)
        end
      end
    end
  end
end
