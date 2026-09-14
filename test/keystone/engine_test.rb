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

  def test_writes_keystone_source_css_from_the_source_stylesheet_during_app_boot
    assert_match(/after_initialize.*keystone_source\.css.*KeystoneUi::SourceCss\.new\(root/m, source)
  end

  def test_writes_the_tailwind_files_and_sources_other_gems_registered_into_keystone_source_css
    assert_includes source, "KeystoneUi::SourceCss.new(root, imports: KeystoneUi.configuration.tailwind_imports, sources: KeystoneUi.configuration.tailwind_sources)"
  end
end
