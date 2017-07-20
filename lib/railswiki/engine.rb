require 'active_record/session_store'
require 'rails-assets-simplemde'

module Railswiki
  class Engine < ::Rails::Engine
    isolate_namespace Railswiki
  end
end
