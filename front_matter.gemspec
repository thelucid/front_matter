# frozen_string_literal: true

require_relative 'lib/front_matter/version'

Gem::Specification.new do |spec|
  spec.name          = 'front_matter'
  spec.version       = FrontMatter::VERSION
  spec.authors       = ['Jamie Hill']
  spec.email         = ['jamie@thelucid.com']

  spec.summary       = 'Smarter YAML front matter parser for Ruby'
  spec.description   = 'Parse front matter from a string or file. Fast, \
                        reliable and easy to use. Parses YAML front matter by \
                        default, but also has support for JSON front matter, \
                        with options to set custom delimiters. Inspired by the \
                        gray-matter JavaScript project.'

  spec.homepage      = 'https://github.com/thelucid/front_matter'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.7.1')

  spec.metadata['allowed_push_host'] = "https://rubygems.pkg.github.com/thelucid'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/thelucid/front_matter'
  spec.metadata['changelog_uri'] = 'https://github.com/thelucid/front_matter/blob/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
