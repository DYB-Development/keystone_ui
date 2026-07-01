# frozen_string_literal: true

require "test_helper"

class NavCssTest < Minitest::Test
  def css_path
    @css_path ||= File.expand_path("../../app/assets/tailwind/keystone_ui_engine/nav.css", __dir__)
  end

  def css
    @css ||= File.read(css_path)
  end

  def test_exists
    assert_equal true, File.exist?(css_path)
  end

  def test_defines_bottom_nav_styles
    assert_includes css, ".bottom-nav"
    assert_includes css, "position: fixed"
  end

  def test_defines_bottom_nav_item_styles
    assert_includes css, ".bottom-nav-item"
    assert_includes css, "flex-direction: column"
  end

  def test_defines_bottom_nav_label_styles
    assert_includes css, ".bottom-nav-label"
  end

  def test_includes_safe_area_inset_for_notched_devices
    assert_includes css, "safe-area-inset-bottom"
  end

  def test_includes_mobile_padding_for_main_content
    assert_includes css, "padding-bottom"
  end

  def test_dropdown_menu_styles_direct_anchor_children
    assert_includes css, "& > a"
  end

  def test_dropdown_menu_items_do_not_wrap
    assert_includes css, "white-space: nowrap"
  end
end
