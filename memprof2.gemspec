Gem::Specification.new do |spec|
  spec.name          = "memprof2"
  spec.version       = "0.1.2"
  spec.authors       = ["Naotoshi Seo"]
  spec.email         = ["sonots@gmail.com"]
  spec.description   = %q{Ruby memory profiler for >= Ruby 2.1.0}
  spec.summary       = %q{Ruby memory profiler for >= Ruby 2.1.0}
  spec.homepage      = "https://github.com/sonots/memprof2"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake"
  spec.add_development_dependency "test-unit"
end
