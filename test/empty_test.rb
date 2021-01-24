# frozen_string_literal: true

require 'test_helper'

class EmptyTest < FrontMatter::Test
  test 'works with empty front matter' do
    result = FrontMatter.parse("---\n---\nThis is content")
    assert_equal 'This is content', result.content
    assert_equal({}, result.data)

    result = FrontMatter.parse("---\n\n---\nThis is content")
    assert_equal 'This is content', result.content
    assert_equal({}, result.data)

    result = FrontMatter.parse("---\n\n\n\n\n\n---\nThis is content")
    assert_equal 'This is content', result.content
    assert_equal({}, result.data)
  end

  test 'adds content with empty front matter to empty value' do
    assert_equal("---\n---", FrontMatter.parse("---\n---").empty)
  end

  test 'adds content with empty front matter to empty value (windows)' do
    assert_equal("---\n---", FrontMatter.parse("---\n---").empty)
  end

  test 'reports empty as true' do
    assert_equal(true, FrontMatter.parse("---\n---").empty?)
  end

  test 'works when front matter has comments' do
    source = "---\n # this is a comment\n# another one\n---"
    assert_equal source, FrontMatter.parse(source).empty
  end
end
