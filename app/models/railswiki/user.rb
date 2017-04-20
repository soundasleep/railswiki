module Railswiki
  class User < ApplicationRecord
    def expose_json
      {
        name: name,
      }
    end
  end
end
