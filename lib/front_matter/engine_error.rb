# frozen_string_literal: true

module FrontMatter
  # Raised when an engine doesn't exist for a language.
  class EngineError < StandardError
    attr_reader :language

    def initialize(message = nil, language:)
      super(message)
      @language = language
    end

    def message
      "#{super}: #{language}"
    end
  end
end
