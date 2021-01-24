# frozen_string_literal: true

require 'test_helper'

class TestTest < FrontMatter::Test
  test 'returns true if the string has front matter' do
    assert_equal true, FrontMatter.test('---\nabc: xyz\n---')
    assert_equal true, FrontMatter.test('~~~\nabc: xyz\n~~~', delimiters: '~~~')
  end

  test 'returns false if the string has front matter' do
    assert_equal false, FrontMatter.test('---\nabc: xyz\n---', delimiters: '~~~')
    assert_equal false, FrontMatter.test('\nabc: xyz\n---')
  end
end
