require_relative "lib/eivid/version"

Gem::Specification.new do |spec|
  
  spec.name        = "eivid"
  spec.version     = Eivid::VERSION

  spec.authors     = ["Jurriaan Schrofer"]
  spec.email       = ["jschrofer@gmail.com"]

  spec.summary     = "Eivid because we can."
  spec.description = "Eivid because we can."
  spec.license     = "MIT"

  # spec.metadata["allowed_push_host"] = "https://eitje.app/"

  spec.homepage                    = "https://github.com/eitje-app/eivid_engine"
  spec.metadata["homepage_uri"]    = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"]   = spec.homepage

  spec.files = Dir[
    "{app,config,db,lib}/**/*", 
    "MIT-LICENSE", 
    "Rakefile", 
    "README.md"
  ]

  spec.add_dependency "rails"
  spec.add_dependency "httparty", "0.17.3"
  spec.add_dependency "amazing_print", "1.3.0"

end
