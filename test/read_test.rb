# frozen_string_literal: true

require 'test_helper'

class ReadTest < RubyMatter::Test
  test 'extracts YAML front matter from results with content' do
    result = RubyMatter.read(fixture('basic.txt'))
    assert_equal 'Basic', result.data['title']
    assert_equal 'this is content.', result.content
  end

  test 'parses complex YAML front matter' do
    result = RubyMatter.read(fixture('complex.md'))
    assert_equal '_gh_pages', result.data['root']
  end

  test 'returns an object when a result is empty' do
    result = RubyMatter.read(fixture('empty.md'))
    assert_equal '', result.original
    assert_equal '', result.content
    assert_equal({}, result.data)
  end

  test 'returns an object when no front matter exists' do
    result = RubyMatter.read(fixture('hasnt-matter.md'))
    assert_equal "# This file doesn't have matter!", result.original
    assert_equal "# This file doesn't have matter!", result.content
    assert_equal({}, result.data)
  end

  test 'parses YAML results directly' do
    result = RubyMatter.read(fixture('all.yaml'))

    assert_equal(
      { 'one' => 'foo', 'two' => 'bar', 'three' => 'baz' },
      result.data
    )
  end
end
