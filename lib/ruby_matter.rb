# frozen_string_literal: true

require 'psych'
require 'json'
require 'ruby_matter/version'
require 'ruby_matter/parser'
require 'ruby_matter/stringifier'
require 'ruby_matter/engine_error'

# Provides the interface for reading, parsing and
# stringifying front matter.
#
module RubyMatter
  DELIMITERS = '---'
  LANGUAGE = 'yaml'
  ALIASES = { 'yml' => 'yaml' }.freeze

  ENGINES = {
    yaml: {
      parse: ->(yaml) { Psych.safe_load(yaml) },
      stringify: ->(hash) { Psych.dump(hash).sub(/^---(\n|\s)?/, '') }
    },
    json: {
      parse: ->(json) { JSON.parse(json) },
      stringify: ->(hash) { JSON.pretty_generate(hash) }
    }
  }.freeze

  # == Parameters
  # Returns a parser instance that extracts +content+,
  # +data+, +excerpt+ and the raw +matter+. If the matter
  # was empty, then an +empty+ value is available
  # containiing the empty front matter with comments.
  #
  # source (String)::
  #   The source containing front matter, for parsing.
  #
  # delimiters (Array|String)::
  #   Opening and closing delimiters. When a string is
  #   supplied, it is used as both delimiters. Defaults to
  #   '\-\-\-', as defined in +DELIMITERS+ constant.
  #
  # language (String)::
  #   The front matter language to use when no directive is
  #   supplied within the matter itself. Defaults to
  #   'yaml', as defined in +LANGUAGE+ constant.
  #
  # aliases (Hash)::
  #   Used to map language aliases, for example 'yaml' can
  #   also be referenced as 'yml'. This is the default, as
  #   defined in the +ALIASES+ constant.
  #
  # engines (Hash)::
  #   A hash of engines, where the key is the language, and
  #   the value is a hash containing a +:parse+ lambda and
  #   a +:stringify+ lamda. Defaults to 'yaml' and 'json'
  #   engines, as defined in the +ENGINES+ constant.
  #
  # excerpt (Boolean|Proc)::
  #   When +true+, extracts the excerpt up to a matching
  #   +excerpt_seperator+; or the closing delimiter from
  #   the +delimiters+ argument by default. When a lambda
  #   is supplied, it is called with the parser instance as
  #   an argument, and is expected to return the excerpt.
  #
  # excerpt_seperator (String)::
  #   Used to specify a custom excerpt seperator. Defaults
  #   to the closing delimiter from +delimiters+.
  #
  # == Returns
  # (RubyMatter::Parser)::
  #   An instance of the parser.
  #
  def self.parse(
    source,
    delimiters: DELIMITERS,
    language: LANGUAGE,
    aliases: ALIASES,
    engines: ENGINES,
    excerpt: nil,
    excerpt_separator: nil
  )
    RubyMatter::Parser.new(
      source,
      delimiters: Array(delimiters),
      language: language,
      aliases: aliases,
      engines: engines.transform_keys(&:to_s),
      excerpt: excerpt,
      excerpt_separator: excerpt_separator
    )
  end

  # == Parameters
  # filepath (String)::
  #   Path to a file containing front matter, for parsing.
  #
  # **options::
  #   All options get passed to through to RubyMatter.parse.
  #
  # == Returns
  # (RubyMatter::Parser)::
  #   An instance of the parser.
  #
  def self.read(filepath, **options)
    parse(File.read(filepath), **options)
  end

  # == Parameters
  # source (String)::
  #   A string to test for front matter.
  #
  # delimiters (Array|String)::
  #   Opening and closing delimiters. When a string is
  #   supplied, it is used as both delimiters. Defaults to
  #   '\-\-\-', as defined in +DELIMITERS+ constant.
  #
  # == Returns
  # (Boolean)::
  #   Whether the source contains front matter.
  #
  def self.test(source, delimiters: DELIMITERS)
    RubyMatter::Parser.new(source, delimiters: Array(delimiters)).matter?
  end

  # == Parameters
  # source (String)::
  #   A string to extract front matter language from.
  #
  # delimiters (Array|String)::
  #   Opening and closing delimiters. When a string is
  #   supplied, it is used as both delimiters. Defaults to
  #   '\-\-\-', as defined in +DELIMITERS+ constant.
  #
  # == Returns
  # (String|nil)::
  #   The front matter language directive if it exists,
  #   otherwise +nil+.
  #
  def self.language(source, delimiters: DELIMITERS)
    RubyMatter::Parser.new(source, delimiters: Array(delimiters)).directive
  end

  # == Parameters
  # content (String)::
  #   The content string that follows the front matter.
  #
  # data (Hash)::
  #   The data that forms the front matter.
  #
  # delimiters (Array|String)::
  #   Opening and closing delimiters. When a string is
  #   supplied, it is used as both delimiters. Defaults to
  #   '\-\-\-', as defined in +DELIMITERS+ constant.
  #
  # language (String)::
  #   The front matter language to use when stringifying
  #   the data. Defaults to 'yaml', as defined in
  #   +LANGUAGE+ constant.
  #
  # engines (Hash)::
  #   A hash of engines, where the key is the language, and
  #   the value is a hash containing a +:parse+ lambda and
  #   a +:stringify+ lamda. Defaults to 'yaml' and 'json'
  #   engines, as defined in the +ENGINES+ constant.
  #
  # excerpt (String)::
  #   The exerpt that comes before the +excerpt_seperator+.
  #
  # excerpt_seperator (String)::
  #   Used to specify a custom excerpt seperator. Defaults
  #   to the closing delimiter from +delimiters+.
  #
  # == Returns
  # (String)::
  #   An string containing front matter, optional excerpt,
  #   and content.
  #
  def self.stringify(
    content,
    data: {},
    delimiters: DELIMITERS,
    language: LANGUAGE,
    engines: ENGINES,
    excerpt: nil,
    excerpt_separator: nil
  )
    RubyMatter::Stringifier.new(
      content,
      data: data,
      delimiters: Array(delimiters),
      language: language,
      engines: engines.transform_keys(&:to_s),
      excerpt: excerpt,
      excerpt_separator: excerpt_separator
    ).stringify
  end
end
