# frozen_string_literal: true

require 'test_helper'

class VersionTest < RubyMatter::Test
  test 'that it has a version number' do
    refute_nil RubyMatter::VERSION
  end
end
