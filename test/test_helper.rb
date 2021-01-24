# frozen_string_literal: true

require 'simplecov'

SimpleCov.start do
  minimum_coverage 98
  add_filter %r{^/test/}
end

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'ruby_matter'

require 'minitest/autorun'

module RubyMatter
  class Test < Minitest::Test
    # Inspired by: https://api.rubyonrails.org/classes/ActiveSupport/Testing/Declarative.html#method-i-test.
    def self.test(name, &block)
      sym = "test_#{name.gsub(/\s+/, '_')}".to_sym
      raise "#{sym} is already defined in #{self}" if method_defined?(sym)
      return define_method(sym, &block) if block_given?

      define_method(sym) { flunk "No implementation provided for #{sym}" }
    end

    def fixture(path)
      File.expand_path(File.join('fixtures', path), __dir__)
    end
  end
end
