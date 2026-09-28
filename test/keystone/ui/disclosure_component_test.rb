# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::DisclosureComponentTest < Minitest::Test
  VISUAL_UTILITY = %r{(?:^|\s)(?:[\w\-\[\]&]+:)*(?:bg-|text-(?!xs\b|sm\b|base\b|lg\b|xl\b|\dxl\b|left\b|center\b|right\b)|border|rounded|shadow|ring|font-(?!mono\b)|p[xytblr]?-|m[xytblr]?-(?!auto\b)|gap-|space-[xy]-|divide-)}

  def test_is_closed_by_default
    refute Keystone::Ui::DisclosureComponent.new.open?
  end

  def test_can_be_opened_by_default
    assert Keystone::Ui::DisclosureComponent.new(open: true).open?
  end

  def test_summary_is_a_clickable_row_with_hidden_native_marker
    classes = Keystone::Ui::DisclosureComponent.new.summary_classes

    assert_includes classes, "cursor-pointer"
    assert_includes classes, "list-none"
  end

  def test_wrapper_classes_render_the_ks_disclosure_class
    assert_includes Keystone::Ui::DisclosureComponent::WRAPPER_CLASSES, "ks-disclosure"
  end

  def test_wrapper_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::DisclosureComponent::WRAPPER_CLASSES
  end

  def test_summary_classes_render_the_ks_disclosure_summary_class
    assert_includes Keystone::Ui::DisclosureComponent::SUMMARY_CLASSES, "ks-disclosure-summary"
  end

  def test_summary_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::DisclosureComponent::SUMMARY_CLASSES
  end

  def test_icon_classes_render_the_ks_disclosure_icon_class
    assert_includes Keystone::Ui::DisclosureComponent::ICON_CLASSES, "ks-disclosure-icon"
  end

  def test_icon_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::DisclosureComponent::ICON_CLASSES
  end

  def test_body_classes_render_the_ks_disclosure_body_class
    assert_includes Keystone::Ui::DisclosureComponent::BODY_CLASSES, "ks-disclosure-body"
  end

  def test_body_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::DisclosureComponent::BODY_CLASSES
  end
end
