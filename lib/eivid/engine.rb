module Eivid
  
  class Engine < ::Rails::Engine    
    
    isolate_namespace Eivid
    config.generators.api_only = true

  end

  mattr_accessor :owner_model, :infer_external_owner_id, :notify_front_enabled, :notify_method_on_upload,
                 :notify_method_on_video_available, :notify_method_on_versions_available

  #sets video owner in the main app
  self.owner_model = nil
  
  # sets how to extract the owner_id in controller actions
  self.infer_external_owner_id = "params['external_owner_id'].to_i"

  # sets front end notifiers
  self.notify_front_enabled = false
  self.notify_method_on_upload = nil
  self.notify_method_on_video_available = nil
  self.notify_method_on_versions_available = nil

  def self.set_mattr_accessors(&block)
    yield self
  end

end
