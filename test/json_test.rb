# frozen_string_literal: true

require 'test_helper'

class JsonTest < RubyMatter::Test
  test 'parses JSON front matter' do
    actual = RubyMatter.read(fixture('lang-json.md'), language: 'json')
    assert_equal 'JSON', actual.data['title']
  end

  test 'auto detects JSON as the language' do
    actual = RubyMatter.read(fixture('autodetect-json.md'))
    assert_equal 'Auto detect JSON', actual.data['title']
  end
end
