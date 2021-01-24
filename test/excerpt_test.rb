# frozen_string_literal: true

require 'test_helper'

class ExcerptTest < FrontMatter::Test
  test 'gets an excerpt after front matter' do
    result = FrontMatter.parse(
      "---\nabc: xyz\n---\nfoo\nbar\nbaz\n---\ncontent",
      excerpt: true
    )

    assert_equal "\nabc: xyz", result.matter
    assert_equal "foo\nbar\nbaz\n---\ncontent", result.content
    assert_equal "foo\nbar\nbaz\n", result.excerpt
    assert_equal 'xyz', result.data['abc']
  end

  test 'does not get excerpt when disabled' do
    result = FrontMatter.parse(
      "---\nabc: xyz\n---\nfoo\nbar\nbaz\n---\ncontent"
    )

    assert_equal "\nabc: xyz", result.matter
    assert_equal "foo\nbar\nbaz\n---\ncontent", result.content
    assert_nil result.excerpt
    assert_equal 'xyz', result.data['abc']
  end

  test 'uses a custom separator' do
    result = FrontMatter.parse(
      "---\nabc: xyz\n---\nfoo\nbar\nbaz\n<!-- endexcerpt -->\ncontent",
      excerpt_separator: '<!-- endexcerpt -->'
    )

    assert_equal "\nabc: xyz", result.matter
    assert_equal "foo\nbar\nbaz\n<!-- endexcerpt -->\ncontent", result.content
    assert_equal "foo\nbar\nbaz\n", result.excerpt
    assert_equal 'xyz', result.data['abc']
  end

  test 'uses a custom separator when no front matter exists' do
    result = FrontMatter.parse(
      "foo\nbar\nbaz\n<!-- endexcerpt -->\ncontent",
      excerpt_separator: '<!-- endexcerpt -->'
    )

    assert_equal '', result.matter
    assert_equal "foo\nbar\nbaz\n<!-- endexcerpt -->\ncontent", result.content
    assert_equal "foo\nbar\nbaz\n", result.excerpt
    assert_equal({}, result.data)
  end

  test 'uses a custom function to get excerpt' do
    result = FrontMatter.parse(
      "---\nabc: xyz\n---\nfoo\nbar\nbaz\n---\ncontent",
      excerpt: ->(instance) { "custom #{instance.data['abc']}" }
    )

    assert_equal "\nabc: xyz", result.matter
    assert_equal "foo\nbar\nbaz\n---\ncontent", result.content
    assert_equal 'custom xyz', result.excerpt
    assert_equal 'xyz', result.data['abc']
  end
end
