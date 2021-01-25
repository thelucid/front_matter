# frozen_string_literal: true

module RubyMatter
  # Parses the supplied +original+ on demand, when the
  # relevant methods are called.
  #
  class Parser
    COMMENT = "^\s*#[^\n]+"
    NEWLINE = "\r?\n"

    attr_reader :original

    # Instantiate the parser. This should not need to be
    # called directly, as the RubyMatter module methods
    # will handle this. For more information, see the
    # following methods that instantiate a parser:
    #
    # * RubyMatter.parse - new parser from a string.
    # * RubyMatter.read - new parser from a file.
    # * RubyMatter.test - test string for front matter.
    # * RubyMatter.language - extract language from a
    #   string containing front matter.
    #
    # == Returns
    # (RubyMatter::Parser)::
    #   An instance of the parser.
    #
    def initialize(
      source,
      delimiters:,
      language: nil,
      aliases: {},
      engines: {},
      excerpt: nil,
      excerpt_separator: nil
    )
      @original = source
      @delimiters = delimiters
      @language_default = language
      @aliases = aliases
      @engines = engines
      @excerpt = excerpt
      @excerpt_separator = excerpt_separator
    end

    # Extracts the data from the front matter.
    #
    # == Returns
    # (Hash)::
    #   The data found in the front matter.
    #
    def data
      return {} unless block?

      engine[:parse].call(matter).then do |value|
        value.is_a?(Hash) ? value : {}
      end
    end

    # If enabled, extracts the excerpt after front matter.
    #
    # == Returns
    # (String|nil)::
    #   The excerpt, or +nil+.
    #
    def excerpt
      return unless @excerpt || @excerpt_separator
      return @excerpt.call(self) if @excerpt.respond_to?(:call)

      content.index(
        @excerpt.is_a?(String) ? @excerpt : @excerpt_separator || opening
      ).then do |index|
        index && content[0...index]
      end
    end

    # Extracts the content from the front matter.
    #
    # == Returns
    # (String)::
    #   The content found in the source.
    #
    def content
      return @original unless matter?

      finish == size ? '' : @original[after..].sub(/^#{NEWLINE}/, '')
    end

    # Extracts the raw front matter block.
    #
    # == Returns
    # (String)::
    #   The raw front matter found in the source.
    #
    def matter
      @matter ||= matter? && @original[start...finish] || ''
    end

    # Whether the source has front matter.
    #
    # == Returns
    # (Boolean)::
    #   Evaluates to +true+ if front matter is present.
    #
    def matter?
      @original.start_with?(opening) && @original[opening.size] != opening[-1]
    end

    # When the front matter is empty (either all
    # whitespace, nothing at all, or just comments and no
    # data), the original string is set on this property.
    #
    # == Returns
    # (String|nil)::
    #   If the front matter was empty, this is the raw
    #   front matter, otherwise +nil+.
    #
    def empty
      @empty ||= block.empty? ? @original : nil
    end

    # Whether the front matter is empty.
    #
    # == Returns
    # (Boolean)::
    #   Evaluates to +true+ if front matter is empty.
    #
    def empty?
      empty != nil
    end

    # The language extracted from the front matter.
    #
    # == Returns
    # (String)::
    #   The raw directive string within the front matter.
    #
    def directive
      @directive ||= extract_directive.then do |raw|
        (raw && raw.strip).then do |name|
          { raw: raw, name: name.empty? ? nil : name }
        end
      end
    end

    # Stringifies using the supplied +delimiters+,
    # +language+, +engines+ and optional +excerpt+. By
    # default, only YAML and JSON can be stringified. See
    # the +engines+ argument for to go about stringifying
    # other languages.
    #
    # == Returns
    # (String)::
    #   The stringified +data+, +excerpt+, and +content+.
    #
    def stringify
      RubyMatter::Stringifier.new(
        content,
        data: data,
        delimiters: @delimiters,
        language: language,
        engines: @engines,
        excerpt: excerpt,
        excerpt_separator: @excerpt_separator
      ).stringify
    end

    private

    # Language from directive or fallback to supplied string.
    def language
      @language ||= (directive[:name] || @language_default).then do |handle|
        @aliases[handle.downcase] || handle
      end
    end

    # Language defined after first delimiter.
    def extract_directive
      return nil unless matter?

      @original[opening.size..].then do |matter|
        matter && matter[0...matter.index(/#{NEWLINE}/)]
      end
    end

    # Engine for language.
    def engine
      @engine ||= @engines[language] || raise(
        EngineError.new(language: language)
      )
    end

    # Raw matter block without comments.
    def block
      matter? ? matter.gsub(/#{COMMENT}/m, '').strip : ''
    end

    # Is there any matter to parse.
    def block?
      !block.empty?
    end

    # Opening delimiter.
    def opening
      @opening ||= @delimiters.first
    end

    # Closing delimiter, with leading newline.
    def closing
      @closing ||= "\n#{@delimiters.last}"
    end

    # Length of the opening delimiter and language.
    def start
      @start ||= directive[:raw].then do |raw|
        raw ? opening.size + raw.size : opening.size
      end
    end

    # Index of closing delimiter.
    def finish
      @finish ||= @original.index(closing, start) || size
    end

    # Index after closing delimiter.
    def after
      @after ||= finish + closing.size
    end

    # Size on the original content.
    def size
      @size ||= @original.size
    end
  end
end
