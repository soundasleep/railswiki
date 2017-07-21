require 'active_record/session_store'
require 'webpacker'

module Railswiki
  class Engine < ::Rails::Engine
    isolate_namespace Railswiki

    attr_accessor :use_slugs

    def initialize
      @use_slugs = false
    end
  end
end
