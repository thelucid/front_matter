# frozen_string_literal: true

module RubyMatter
  # Stringifies +data+, +content+ and optional +excerpt+,
  # based on the arguments supplied to the initializer.
  #
  class Stringifier
    # Instantiate the stringifier. This should not need to
    # be called directly, as the RubyMatter module methods
    # will handle this. For more information, see the
    # following method that instantiates a stringifier:
    #
    # * RubyMatter.stringify - stringify +data+, +content+ and optional +excerpt+.
    #
    # == Returns
    # (RubyMatter::Stringifier)::
    #   An instance of the stringifier.
    #
    def initialize(
      content,
      data,
      delimiters:,
      language: nil,
      engines: {},
      excerpt: nil,
      excerpt_separator: nil
    )
      @content = content
      @data = data
      @delimiters = delimiters
      @language = language
      @engines = engines
      @excerpt = excerpt
      @excerpt_separator = excerpt_separator
    end

    # Stringifies +content+, +data+, and optional +excerpt+,
    # using the +delimiters+, +language+ and +engines+.
    #
    # == Returns
    # (String)::
    #   The result of stringifying the supplied arguments.
    #
    def stringify
      matter + excerpt + content
    end

    private

    def engine
      @engine ||= @engines[@language]
    end

    def stringifier
      @stringifier ||= (
        engine && engine[:stringify]
      ) || raise(EngineError.new(language: language))
    end

    def opening
      @delimiters.first
    end

    def closing
      @delimiters.last
    end

    def seperator
      @excerpt_separator || closing
    end

    def matter
      stringifier.call(@data).then do |string|
        return '' if string.strip == '{}'

        newline(opening) + newline(string) + newline(closing)
      end
    end

    def excerpt
      return '' unless @excerpt

      newline(@excerpt) + newline(seperator)
    end

    def content
      newline(@content)
    end

    def newline(line)
      line[-1] == "\n" ? line : "#{line}\n"
    end
  end
end
