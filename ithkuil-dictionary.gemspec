# require_relative 'lib/ithkuil/dictionary/version'

Gem::Specification.new do |spec|
  spec.name          = "ithkuil-dictionary"
  spec.version       = 0.1
  spec.authors       = ["asengelhart"]
  spec.email         = ["asengelhart@yahoo.com"]

  spec.summary       = "Ithkuil dictionary scraper"
  # spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = 'https://github.com/asengelhart/ithkuil-dictionary'
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = 'https://github.com/asengelhart/ithkuil-dictionary'

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = 'https://github.com/asengelhart/ithkuil-dictionary'
  spec.metadata["changelog_uri"] = 'https://github.com/asengelhart/ithkuil-dictionary'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
