# frozen_string_literal: true

require 'test_helper'

class LanguageTest < FrontMatter::Test
  test 'should detect the name of the language to parse' do
    assert_equal(
      { raw: '', name: nil },
      FrontMatter.language("---\nfoo: bar\n---")
    )
    assert_equal(
      { raw: 'js', name: 'js' },
      FrontMatter.language("---js\nfoo: bar\n---")
    )
    assert_equal(
      { raw: 'coffee', name: 'coffee' },
      FrontMatter.language("---coffee\nfoo: bar\n---")
    )
  end

  test 'should work around whitespace' do
    assert_equal(
      { raw: ' ', name: nil },
      FrontMatter.language("--- \nfoo: bar\n---")
    )
    assert_equal(
      { raw: ' js ', name: 'js' },
      FrontMatter.language("--- js \nfoo: bar\n---")
    )
    assert_equal(
      { raw: '  coffee ', name: 'coffee' },
      FrontMatter.language("---  coffee \nfoo: bar\n---")
    )
  end
end
