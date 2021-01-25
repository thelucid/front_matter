# frozen_string_literal: true

require 'test_helper'

class StringifyTest < RubyMatter::Test
  test 'stringifies parser front matter' do
    parser = RubyMatter.parse("---\nname: front matter\n---\nName: {{name}}")
    assert_equal(
      "---\nname: front matter\n---\nName: {{name}}\n",
      parser.stringify
    )
  end

  test 'stringifies from a string' do
    assert_equal "Name: {{name}}\n", RubyMatter.stringify("Name: {{name}}\n")
  end

  test 'uses custom delimiters to stringify' do
    actual = RubyMatter.stringify(
      'Name: {{name}}',
      data: { 'name' => 'front matter' },
      delimiters: '~~~'
    )

    assert_equal "~~~\nname: front matter\n~~~\nName: {{name}}\n", actual
  end

  test 'stringifies an excerpt' do
    actual = RubyMatter.stringify(
      'Name: {{name}}',
      data: { 'name' => 'front matter' },
      excerpt: 'This is an excerpt.'
    )

    assert_equal(
      "---\nname: front matter\n---\nThis is an excerpt.\n---\nName: {{name}}\n",
      actual
    )
  end

  test 'stringifies an excerpt with custom seperator' do
    actual = RubyMatter.stringify(
      'Name: {{name}}',
      data: { 'name' => 'front matter' },
      excerpt: 'This is an excerpt.',
      excerpt_separator: '<!-- sep -->'
    )

    assert_equal(
      "---\nname: front matter\n---\nThis is an excerpt.\n<!-- sep -->\nName: {{name}}\n",
      actual
    )
  end

  test 'stringifies as json' do
    assert_equal(
      "---\n{\n  \"name\": \"front matter\"\n}\n---\nName: {{name}}\n",
      RubyMatter.stringify(
        "Name: {{name}}\n",
        data: { 'name' => 'front matter' },
        language: 'json'
      )
    )
  end
end
