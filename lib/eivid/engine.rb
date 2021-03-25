module Eivid
  
  class Engine < ::Rails::Engine    
    
    # default engine config
    isolate_namespace Eivid
    config.generators.api_only = true

  end

  # mattr_accessor config, with setting defaults first

  self.mattr_accessor :owner_model
  self.owner_model = "owner"

  def self.set_mattr_accessors(&block)
    yield self
  end

end
