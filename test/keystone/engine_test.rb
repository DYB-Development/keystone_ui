# frozen_string_literal: true

require "test_helper"

class KeystoneUiEngineTest < Minitest::Test
  def source
    @source ||= File.read(File.expand_path("../../lib/keystone_ui/engine.rb", __dir__))
  end

  def test_does_not_reference_theme_css_files
    refute_includes source, "themes/base.css"
    refute_includes source, "themes/dark.css"
  end

  def test_writes_keystone_source_css_with_source_path_during_app_boot
    assert_includes source, "after_initialize"
    assert_includes source, "keystone_source.css"
    assert_includes source, "app/components/**/*.{erb,rb}"
  end

  def test_imports_nav_css_in_keystone_source_css
    assert_includes source, "nav.css"
    assert_includes source, '@import "#{nav_css}"'
  end
end
