# frozen_string_literal: true

require "test_helper"
require_relative "../../lib/keystone_ui/source_css"

class KeystoneUi::SourceCssTest < Minitest::Test
  ROOT = Pathname.new("/gems/keystone_ui")

  def test_points_tailwind_at_the_component_files
    assert_includes css, %(@source "/gems/keystone_ui/app/components/**/*.{erb,rb}";)
  end

  def test_imports_the_navigation_styles
    assert_includes css, %(@import "/gems/keystone_ui/app/assets/tailwind/keystone_ui_engine/nav.css";)
  end

  private

  def css
    KeystoneUi::SourceCss.new(ROOT).to_s
  end
end
