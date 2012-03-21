# Provide a simple gemspec so you can easily use your enginex
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name = "mobileappmgr"
  s.summary = "Insert Mobileappmgr summary."
  s.description = "Insert Mobileappmgr description."
  s.files = Dir["{recipes,app,lib,config}/**/*"] + ["MIT-LICENSE", "Rakefile", "Gemfile", "README.rdoc"]
  s.version = "0.0.1"
end
