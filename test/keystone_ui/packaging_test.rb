# frozen_string_literal: true

require "test_helper"
require "rubygems"

class KeystoneUi::PackagingTest < Minitest::Test
  ROOT = File.expand_path("../..", __dir__)

  def test_packaged_files_include_the_importmap_the_engine_pins
    assert_includes packaged_files, "config/importmap.rb"
  end

  def test_packaged_files_include_the_committed_locals
    assert_includes packaged_files, "the_local/agents/keystone_ui-develop.md"
  end

  private

  def packaged_files
    Dir.chdir(ROOT) { Gem::Specification.load(File.join(ROOT, "keystone_ui.gemspec")).files }
  end
end
