require_relative "boot"
require 'rails/all'

Bundler.require(*Rails.groups)
require "eivid"

module Dummy
  class Application < Rails::Application
    
    config.eager_load_paths << "app/models"
    config.eager_load_paths << "app/errors"
    config.eager_load_paths << "app/services"

    config.load_defaults Rails::VERSION::STRING.to_f
    config.api_only = true
  end
end
