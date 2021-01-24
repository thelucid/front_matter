# frozen_string_literal: true

require 'test_helper'

class ParseTest < RubyMatter::Test
  test 'parses yaml front matter' do
    actual = RubyMatter.parse("---\nabc: xyz\n---")
    assert actual.respond_to?(:data)
    assert actual.respond_to?(:content)
    assert actual.respond_to?(:original)
    assert_equal 'xyz', actual.data['abc']
  end

  test 'retains original string' do
    source = "---\nabc: xyz\n---"
    actual = RubyMatter.parse(source)
    assert_equal source, actual.original
  end

  test 'extra characters should throw parsing errors' do
    exception = assert_raises(RubyMatter::EngineError) do
      RubyMatter.parse("---whatever\nabc: xyz\n---").data
    end
    
    assert_equal 'RubyMatter::EngineError: whatever', exception.message
  end

  test 'boolean yaml types still return the empty object' do
    actual = RubyMatter.parse("--- true\n---")
    assert_equal({}, actual.data)
  end

  test 'string yaml types should still return the empty object' do
    actual = RubyMatter.parse("--- true\n---")
    assert_equal({}, actual.data)
  end

  test 'number yaml types should still return the empty object' do
    actual = RubyMatter.parse("--- 42\n---")
    assert_equal({}, actual.data)
  end

  test 'raises an error when a string is not passed' do
    assert_raises ArgumentError do
      RubyMatter.parse
    end
  end

  test 'string is zero length' do
    actual = RubyMatter.parse('')
    assert_equal({}, actual.data)
    assert_equal '', actual.content
    assert_equal '', actual.original
  end

  test 'parses yaml front matter and content' do
    source = "---\nabc: xyz\nversion: 2\n---\n\n<span class=\"alert alert-info\">This is an alert</span>\n"
    actual = RubyMatter.parse(source)
    assert_equal({ 'abc' => 'xyz', 'version' => 2 }, actual.data)
    assert_equal "\n<span class=\"alert alert-info\">This is an alert</span>\n", actual.content
    assert_equal source, actual.original
  end

  test 'uses a custom delimiter as a string' do
    source = "~~~\nabc: xyz\nversion: 2\n~~~\n\n<span class=\"alert alert-info\">This is an alert</span>\n"
    actual = RubyMatter.parse(source, delimiters: '~~~')
    assert_equal({ 'abc' => 'xyz', 'version' => 2 }, actual.data)
    assert_equal "\n<span class=\"alert alert-info\">This is an alert</span>\n", actual.content
    assert_equal source, actual.original
  end

  test 'uses custom delimiters as an array' do
    source = "~~~\nabc: xyz\nversion: 2\n~~~\n\n<span class=\"alert alert-info\">This is an alert</span>\n"
    actual = RubyMatter.parse(source, delimiters: ['~~~'])
    assert_equal({ 'abc' => 'xyz', 'version' => 2 }, actual.data)
    assert_equal "\n<span class=\"alert alert-info\">This is an alert</span>\n", actual.content
    assert_equal source, actual.original
  end

  test 'correctly identifies delimiters and ignore strings that look like delimiters' do
    source = "---\nname: \"troublesome --- value\"\n---\nhere is some content\n"
    actual = RubyMatter.parse(source)
    assert_equal({ 'name' => 'troublesome --- value' }, actual.data)
    assert_equal "here is some content\n", actual.content
    assert_equal "---\nname: \"troublesome --- value\"\n---\nhere is some content\n", actual.original
  end

  test 'correctly parses a string that only has an opening delimiter' do
    source = "---\nname: \"troublesome --- value\"\n"
    actual = RubyMatter.parse(source)
    assert_equal({ 'name' => 'troublesome --- value' }, actual.data)
    assert_equal '', actual.content
    assert_equal "---\nname: \"troublesome --- value\"\n", actual.original
  end

  test 'does not try to parse a string has content that looks like front matter' do
    source = "-----------name--------------value\nfoo"
    actual = RubyMatter.parse(source)
    assert_equal({}, actual.data)
    assert_equal "-----------name--------------value\nfoo", actual.content
    assert_equal "-----------name--------------value\nfoo", actual.original
  end
end
