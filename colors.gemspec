
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "colors"
  spec.version       = '0.0.1'
  spec.authors       = ["tehAnswer"]
  spec.email         = ["sergiorodriguezgijon@gmail.com"]

  spec.summary       = 'Bitmap editor simulator'
  spec.description   = 'This gem enables to their users to print beautiful and fully colorized messages through a small scripting language.'
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_dependency 'dry-struct'
  spec.add_dependency 'colorize'
  spec.add_dependency 'dry-container'

  spec.add_development_dependency 'rspec', '~> 3.7.0'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'simplecov', '~> 0.15.1'
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
end
