$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "railswiki/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "railswiki"
  s.version     = Railswiki::VERSION
  s.authors     = ["Jevon Wright"]
  s.email       = ["jevon@jevon.org"]
  s.homepage    = "https://github.com/soundasleep/railswiki"
  s.summary     = "A wiki engine in Rails 5."
  s.description = "A wiki engine in Rails 5."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1"

  # Login
  s.add_dependency "omniauth-google-oauth2", "~> 0"
  s.add_dependency "activerecord-session_store", "~> 0"

  # Rendering
  s.add_dependency "redcarpet", "~> 0"

  # Upload
  s.add_dependency "carrierwave", "~> 1.0"

  # Misc
  s.add_dependency "email_validator", "~> 0"

  s.add_dependency "webpacker", "~> 2.0"

  s.add_development_dependency "sqlite3", "~> 0"
end
