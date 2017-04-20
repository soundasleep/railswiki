require 'active_record/session_store'

module Railswiki
  class Engine < ::Rails::Engine
    isolate_namespace Railswiki
  end
end
