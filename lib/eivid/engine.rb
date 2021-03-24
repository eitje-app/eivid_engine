module Eivid
  class Engine < ::Rails::Engine
    isolate_namespace Eivid
    config.generators.api_only = true
  end
end
