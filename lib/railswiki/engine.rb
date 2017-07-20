require 'active_record/session_store'
require 'webpacker'

module Railswiki
  class Engine < ::Rails::Engine
    isolate_namespace Railswiki
  end
end
