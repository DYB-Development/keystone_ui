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

  def test_packaged_files_include_the_license_the_gemspec_declares
    assert_includes packaged_files, "MIT-LICENSE"
  end

  def test_view_component_dependency_excludes_the_next_major
    requirement = gemspec.dependencies.find { |d| d.name == "view_component" }.requirement

    refute requirement.satisfied_by?(Gem::Version.new("5.0.0"))
  end

  private

  def gemspec
    Dir.chdir(ROOT) { Gem::Specification.load(File.join(ROOT, "keystone_ui.gemspec")) }
  end

  def packaged_files
    gemspec.files
  end
end
