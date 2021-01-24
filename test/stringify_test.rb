# frozen_string_literal: true

require 'test_helper'

class StringifyTest < FrontMatter::Test
  test 'stringifies parser front matter' do
    parser = FrontMatter.parse("---\nname: front matter\n---\nName: {{name}}")
    assert_equal(
      "---\nname: front matter\n---\nName: {{name}}\n",
      parser.stringify
    )
  end

  test 'stringifies from a string' do
    assert_equal "Name: {{name}}\n", FrontMatter.stringify("Name: {{name}}\n")
  end

  test 'uses custom delimiters to stringify' do
    actual = FrontMatter.stringify(
      'Name: {{name}}',
      { 'name' => 'front matter' },
      delimiters: '~~~'
    )

    assert_equal "~~~\nname: front matter\n~~~\nName: {{name}}\n", actual
  end

  test 'stringifies an excerpt' do
    actual = FrontMatter.stringify(
      'Name: {{name}}',
      { 'name' => 'front matter' },
      excerpt: 'This is an excerpt.'
    )

    assert_equal(
      "---\nname: front matter\n---\nThis is an excerpt.\n---\nName: {{name}}\n",
      actual
    )
  end

  test 'stringifies an excerpt with custom seperator' do
    actual = FrontMatter.stringify(
      'Name: {{name}}',
      { 'name' => 'front matter' },
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
      FrontMatter.stringify(
        "Name: {{name}}\n",
        { 'name' => 'front matter' },
        language: 'json'
      )
    )
  end
end
