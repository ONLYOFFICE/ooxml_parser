# frozen_string_literal: true

require_relative 'lib/ooxml_parser/name'
require_relative 'lib/ooxml_parser/version'

Gem::Specification.new do |s|
  s.name = OoxmlParser::Name::STRING
  s.version = OoxmlParser::Version::STRING
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 3.1'
  s.authors = ['ONLYOFFICE', 'Pavel Lobashov', 'Roman Zagudaev']
  s.email = %w[shockwavenn@gmail.com rzagudaev@gmail.com]
  s.summary = 'OoxmlParser Gem'
  s.description = 'Parse OOXML files (docx, xlsx, pptx)'
  s.homepage = "https://github.com/onlyoffice/#{s.name}"
  s.metadata = {
    'bug_tracker_uri' => "#{s.homepage}/issues",
    'changelog_uri' => "#{s.homepage}/blob/master/CHANGELOG.md",
    'documentation_uri' => "https://www.rubydoc.info/gems/#{s.name}",
    'homepage_uri' => s.homepage,
    'source_code_uri' => s.homepage,
    'rubygems_mfa_required' => 'true'
  }
  s.files = Dir['lib/**/*']
  s.license = 'AGPL-3.0'
  s.add_dependency('nokogiri', '~> 1')
  s.add_dependency('ooxml_decrypt', '~> 1')
  s.add_dependency('rubyzip', '>= 2', '< 4')
end
