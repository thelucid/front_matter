# frozen_string_literal: true

require 'test_helper'

class JsonTest < FrontMatter::Test
  test 'parses JSON front matter' do
    actual = FrontMatter.read(fixture('lang-json.md'), language: 'json')
    assert_equal 'JSON', actual.data['title']
  end

  test 'auto detects JSON as the language' do
    actual = FrontMatter.read(fixture('autodetect-json.md'))
    assert_equal 'Auto detect JSON', actual.data['title']
  end
end
