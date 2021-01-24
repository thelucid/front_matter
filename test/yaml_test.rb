# frozen_string_literal: true

require 'test_helper'

class YamlTest < FrontMatter::Test
  test 'parses YAML' do
    actual = FrontMatter.read(fixture('all.yaml'))
    assert_equal({
                   'one' => 'foo',
                   'two' => 'bar',
                   'three' => 'baz'
                 }, actual.data)
  end

  test 'parses YAML with closing ...' do
    actual = FrontMatter.read(fixture('all-dots.yaml'))
    assert_equal({
                   'one' => 'foo',
                   'two' => 'bar',
                   'three' => 'baz'
                 }, actual.data)
  end

  test 'parses YAML front matter' do
    actual = FrontMatter.read(fixture('lang-yaml.md'))
    assert_equal 'YAML', actual.data['title']
  end

  test 'detects YAML as the language with no language defined after the first fence' do
    actual = FrontMatter.read(fixture('autodetect-no-lang.md'))
    assert_equal 'autodetect-no-lang', actual.data['title']
  end

  test 'detects YAML as the language' do
    actual = FrontMatter.read(fixture('autodetect-yaml.md'))
    assert_equal 'autodetect-yaml', actual.data['title']
  end
end
