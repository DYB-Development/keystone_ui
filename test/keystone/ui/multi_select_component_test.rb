# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::MultiSelectComponentTest < Minitest::Test
  VISUAL_UTILITY = %r{(?:^|\s)(?:[\w\-\[\]&]+:)*(?:bg-|text-(?!xs\b|sm\b|base\b|lg\b|xl\b|\dxl\b|left\b|center\b|right\b)|border|rounded|shadow|ring|font-(?!mono\b)|p[xytblr]?-|m[xytblr]?-(?!auto\b)|gap-|space-[xy]-|divide-)}

  def test_returns_display_text_as_all_label_when_nothing_selected
    component = Keystone::Ui::MultiSelectComponent.new(name: "cat[]", label: "Categories", options: [ [ "Shoes", 1 ] ])

    assert_equal "All Categories", component.display_text
  end

  def test_returns_count_when_items_are_selected
    component = Keystone::Ui::MultiSelectComponent.new(name: "cat[]", label: "Categories", options: [ [ "Shoes", 1 ], [ "Hats", 2 ] ], selected: [ "1", "2" ])

    assert_equal "2 selected", component.display_text
  end

  def test_reports_whether_a_value_is_selected
    component = Keystone::Ui::MultiSelectComponent.new(name: "cat[]", label: "Categories", options: [ [ "Shoes", 1 ], [ "Hats", 2 ] ], selected: [ 1 ])

    assert_equal true, component.selected?(1)
    assert_equal false, component.selected?(2)
  end

  def test_trigger_classes_render_the_ks_menu_trigger_class
    assert_includes Keystone::Ui::MultiSelectComponent::TRIGGER_CLASSES, "ks-menu-trigger"
  end

  def test_trigger_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::MultiSelectComponent::TRIGGER_CLASSES
  end

  def test_menu_classes_render_the_ks_menu_class
    assert_includes Keystone::Ui::MultiSelectComponent::MENU_CLASSES, "ks-menu"
  end

  def test_menu_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::MultiSelectComponent::MENU_CLASSES
  end
end
