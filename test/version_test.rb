# frozen_string_literal: true

require 'test_helper'

class VersionTest < FrontMatter::Test
  test 'that it has a version number' do
    refute_nil FrontMatter::VERSION
  end
end
