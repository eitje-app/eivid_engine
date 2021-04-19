module Eivid
  
  class Engine < ::Rails::Engine    
    
    isolate_namespace Eivid
    config.generators.api_only = true

  end

  class << self

    mattr_accessor :owner_model, :infer_external_owner_id

    self.owner_model = "owner"
    self.infer_external_owner_id = "params['external_owner_id'].to_i"

    def set_mattr_accessors(&block)
      yield self
    end

  end

end
