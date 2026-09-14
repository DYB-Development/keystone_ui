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

  def test_imports_the_color_picker_styles
    assert_includes css, %(@import "/gems/keystone_ui/app/assets/tailwind/keystone_ui_engine/color_picker.css";)
  end

  def test_imports_the_keystone_ui_styles_entry_file
    entry = KeystoneUi::Styles::Engine.root.join("app/assets/tailwind/keystone_ui_styles/engine.css")

    assert_includes css, %(@import "#{entry}";)
  end

  def test_imports_the_grid_column_safelist
    assert_includes css, %(@import "/gems/keystone_ui/app/assets/tailwind/keystone_ui_engine/grid_safelist.css";)
  end

  def test_points_tailwind_at_source_files_another_gem_registered
    css = KeystoneUi::SourceCss.new(ROOT, sources: [ "/gems/alembic/app/views/**/*.erb" ]).to_s

    assert_includes css, %(@source "/gems/alembic/app/views/**/*.erb";)
  end

  def test_imports_tailwind_files_another_gem_registered
    css = KeystoneUi::SourceCss.new(ROOT, imports: [ "/gems/alembic/app/assets/tailwind/alembic.css" ]).to_s

    assert_includes css, %(@import "/gems/alembic/app/assets/tailwind/alembic.css";)
  end

  private

  def css
    KeystoneUi::SourceCss.new(ROOT).to_s
  end
end
