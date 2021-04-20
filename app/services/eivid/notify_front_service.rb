module Eivid::NotifyFrontService   
  class << self

    def progress(progress_method, progress_hash)
      return unless Eivid.notify_front_enabled
      
      main_app_proc = Eivid.send progress_method
      main_app_meth = main_app_proc.call progress_hash.deep_symbolize_keys

      eval main_app_meth
    end

  end
end