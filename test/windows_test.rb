# frozen_string_literal: true

require 'test_helper'

class WindowsTest < FrontMatter::Test
  test 'parses yaml front matter (windows)' do
    actual = FrontMatter.parse("---\r\nabc: xyz\r\n---")
    assert actual.respond_to?(:data)
    assert actual.respond_to?(:content)
    assert actual.respond_to?(:original)
    assert_equal 'xyz', actual.data['abc']
  end

  test 'retains original string (windows)' do
    source = "---\r\nabc: xyz\r\n---"
    actual = FrontMatter.parse(source)
    assert_equal source, actual.original
  end

  test 'extra characters should throw parsing errors (windows)' do
    exception = assert_raises(FrontMatter::EngineError) do
      FrontMatter.parse("---whatever\r\nabc: xyz\r\n---").data
    end
    
    assert_equal 'FrontMatter::EngineError: whatever', exception.message
  end

  test 'boolean yaml types still return the empty object (windows)' do
    actual = FrontMatter.parse("--- true\r\n---")
    assert_equal({}, actual.data)
  end

  test 'string yaml types should still return the empty object (windows)' do
    actual = FrontMatter.parse("--- true\r\n---")
    assert_equal({}, actual.data)
  end

  test 'number yaml types should still return the empty object (windows)' do
    actual = FrontMatter.parse("--- 42\r\n---")
    assert_equal({}, actual.data)
  end

  test 'parses yaml front matter and content (windows)' do
    source = "---\r\nabc: xyz\r\nversion: 2\r\n---\r\n\r\n<span class=\"alert alert-info\">This is an alert</span>\r\n"
    actual = FrontMatter.parse(source)
    assert_equal({ 'abc' => 'xyz', 'version' => 2 }, actual.data)
    assert_equal "\r\n<span class=\"alert alert-info\">This is an alert</span>\r\n", actual.content
    assert_equal source, actual.original
  end

  test 'uses a custom delimiter as a string (windows)' do
    source = "~~~\r\nabc: xyz\r\nversion: 2\r\n~~~\r\n\r\n<span class=\"alert alert-info\">This is an alert</span>\r\n"
    actual = FrontMatter.parse(source, delimiters: '~~~')
    assert_equal({ 'abc' => 'xyz', 'version' => 2 }, actual.data)
    assert_equal "\r\n<span class=\"alert alert-info\">This is an alert</span>\r\n", actual.content
    assert_equal source, actual.original
  end

  test 'uses custom delimiters as an array (windows)' do
    source = "~~~\r\nabc: xyz\r\nversion: 2\r\n~~~\r\n\r\n<span class=\"alert alert-info\">This is an alert</span>\r\n"
    actual = FrontMatter.parse(source, delimiters: ['~~~'])
    assert_equal({ 'abc' => 'xyz', 'version' => 2 }, actual.data)
    assert_equal "\r\n<span class=\"alert alert-info\">This is an alert</span>\r\n", actual.content
    assert_equal source, actual.original
  end

  test 'correctly identifies delimiters and ignore strings that look like delimiters (windows)' do
    source = "---\r\nname: \"troublesome --- value\"\r\n---\r\nhere is some content\r\n"
    actual = FrontMatter.parse(source)
    assert_equal({ 'name' => 'troublesome --- value' }, actual.data)
    assert_equal "here is some content\r\n", actual.content
    assert_equal "---\r\nname: \"troublesome --- value\"\r\n---\r\nhere is some content\r\n", actual.original
  end

  test 'correctly parses a string that only has an opening delimiter (windows)' do
    source = "---\r\nname: \"troublesome --- value\"\r\n"
    actual = FrontMatter.parse(source)
    assert_equal({ 'name' => 'troublesome --- value' }, actual.data)
    assert_equal '', actual.content
    assert_equal "---\r\nname: \"troublesome --- value\"\r\n", actual.original
  end

  test 'does not try to parse a string has content that looks like front matter (windows)' do
    source = "-----------name--------------value\r\nfoo"
    actual = FrontMatter.parse(source)
    assert_equal({}, actual.data)
    assert_equal "-----------name--------------value\r\nfoo", actual.content
    assert_equal "-----------name--------------value\r\nfoo", actual.original
  end
end
