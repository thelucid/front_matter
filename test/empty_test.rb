# frozen_string_literal: true

require 'test_helper'

class EmptyTest < RubyMatter::Test
  test 'works with empty front matter' do
    result = RubyMatter.parse("---\n---\nThis is content")
    assert_equal 'This is content', result.content
    assert_equal({}, result.data)

    result = RubyMatter.parse("---\n\n---\nThis is content")
    assert_equal 'This is content', result.content
    assert_equal({}, result.data)

    result = RubyMatter.parse("---\n\n\n\n\n\n---\nThis is content")
    assert_equal 'This is content', result.content
    assert_equal({}, result.data)
  end

  test 'adds content with empty front matter to empty value' do
    assert_equal("---\n---", RubyMatter.parse("---\n---").empty)
  end

  test 'adds content with empty front matter to empty value (windows)' do
    assert_equal("---\n---", RubyMatter.parse("---\n---").empty)
  end

  test 'reports empty as true' do
    assert_equal(true, RubyMatter.parse("---\n---").empty?)
  end

  test 'works when front matter has comments' do
    source = "---\n # this is a comment\n# another one\n---"
    assert_equal source, RubyMatter.parse(source).empty
  end
end
