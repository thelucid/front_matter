# frozen_string_literal: true

require 'test_helper'

class CustomTest < RubyMatter::Test
  test 'allows a custom parser to be registered' do
    actual = RubyMatter.read(
      fixture('lang-yaml.md'),
      engines: {
        yaml: {
          parse: lambda { |yaml|
            Psych.safe_load(yaml).tap do |hash|
              hash['title'] = "#{hash['title']} Special"
            end
          }
        }
      }
    )

    assert_equal 'YAML Special', actual.data['title']
  end
end
