# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::MobileHeaderComponentTest < Minitest::Test
  VISUAL_UTILITY = %r{(?:^|\s)(?:[\w\-\[\]&]+:)*(?:bg-|text-(?!xs\b|sm\b|base\b|lg\b|xl\b|\dxl\b|left\b|center\b|right\b)|border|rounded|shadow|ring|font-(?!mono\b)|p[xytblr]?-|m[xytblr]?-(?!auto\b)|gap-|space-[xy]-|divide-)}

  def test_has_wrapper_classes_hidden_on_large_screens
    assert_includes Keystone::Ui::MobileHeaderComponent::WRAPPER_CLASSES, "lg:hidden"
  end

  def test_subtitle_starts_at_the_left_under_the_title
    refute_includes Keystone::Ui::MobileHeaderComponent::SUBTITLE_CLASSES.split, "text-center"
  end

  def test_has_subtitle_classes_with_small_text
    assert_includes Keystone::Ui::MobileHeaderComponent::SUBTITLE_CLASSES, "text-xs"
    assert_includes Keystone::Ui::MobileHeaderComponent::SUBTITLE_CLASSES, "truncate"
  end


  def test_back_arrow_is_centred_vertically_in_the_bar
    assert_includes Keystone::Ui::MobileHeaderComponent::WRAPPER_CLASSES.split, "items-center"
  end

  def test_has_title_classes_with_truncation
    assert_includes Keystone::Ui::MobileHeaderComponent::TITLE_CLASSES, "truncate"
  end

  def test_title_is_not_taken_out_of_the_bars_layout
    refute_includes Keystone::Ui::MobileHeaderComponent::TITLE_CLASSES.split, "absolute"
  end

  def test_title_takes_the_space_the_controls_leave
    assert_includes Keystone::Ui::MobileHeaderComponent::TITLE_CLASSES.split, "flex-[1_1_6rem]"
  end

  def test_title_can_shrink_below_the_width_of_its_text
    assert_includes Keystone::Ui::MobileHeaderComponent::TITLE_CLASSES.split, "min-w-0"
  end

  def test_title_is_centred_vertically_in_the_bar
    assert_includes Keystone::Ui::MobileHeaderComponent::TITLE_CLASSES.split, "self-center"
  end

  def test_hides_title_on_large_screens_with_lg_hidden
    assert_includes Keystone::Ui::MobileHeaderComponent::TITLE_CLASSES, "lg:hidden"
  end

  def test_has_a_frozen_svg_back_icon
    assert Keystone::Ui::MobileHeaderComponent::BACK_ICON.frozen?
    assert_includes Keystone::Ui::MobileHeaderComponent::BACK_ICON, "<svg"
  end

  def test_back_link_classes_render_the_ks_mobile_header_back_class
    assert_includes Keystone::Ui::MobileHeaderComponent::BACK_LINK_CLASSES, "ks-mobile-header-back"
  end

  def test_back_link_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::MobileHeaderComponent::BACK_LINK_CLASSES
  end

  def test_title_classes_render_the_ks_mobile_header_title_class
    assert_includes Keystone::Ui::MobileHeaderComponent::TITLE_CLASSES, "ks-mobile-header-title"
  end

  def test_title_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::MobileHeaderComponent::TITLE_CLASSES
  end

  def test_subtitle_classes_render_the_ks_mobile_header_subtitle_class
    assert_includes Keystone::Ui::MobileHeaderComponent::SUBTITLE_CLASSES, "ks-mobile-header-subtitle"
  end

  def test_subtitle_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::MobileHeaderComponent::SUBTITLE_CLASSES
  end
end
