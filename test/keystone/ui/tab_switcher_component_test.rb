# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::TabSwitcherComponentTest < Minitest::Test
  VISUAL_UTILITY = %r{(?:^|\s)(?:[\w\-\[\]&]+:)*(?:bg-|text-(?!xs\b|sm\b|base\b|lg\b|xl\b|\dxl\b|left\b|center\b|right\b)|border|rounded|shadow|ring|font-(?!mono\b)|p[xytblr]?-|m[xytblr]?-(?!auto\b)|gap-|space-[xy]-|divide-)}

  def test_returns_base_wrapper_classes
    component = Keystone::Ui::TabSwitcherComponent.new(tabs: [ "One", "Two" ])

    assert_equal "ks-tab-bar flex flex-wrap justify-center", component.classes
  end

  def test_stores_tab_labels
    component = Keystone::Ui::TabSwitcherComponent.new(tabs: [ "Alpha", "Beta", "Gamma" ])

    assert_equal [ "Alpha", "Beta", "Gamma" ], component.tabs
  end



  def test_exposes_panel_classes_as_hidden
    component = Keystone::Ui::TabSwitcherComponent.new(tabs: [ "A" ])

    assert_equal "hidden", component.panel_classes
  end


  def test_wires_the_tab_switcher_stimulus_controller
    component = Keystone::Ui::TabSwitcherComponent.new(tabs: [ "A", "B" ])

    assert_equal "tab-switcher", component.wrapper_data[:controller]
  end

  def test_tab_bar_classes_render_the_ks_tab_bar_class
    assert_includes Keystone::Ui::TabSwitcherComponent::TAB_BAR_CLASSES, "ks-tab-bar"
  end

  def test_tab_bar_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::TabSwitcherComponent::TAB_BAR_CLASSES
  end

  def test_tab_base_classes_render_the_ks_tab_class
    assert_includes Keystone::Ui::TabSwitcherComponent::TAB_BASE_CLASSES, "ks-tab"
  end

  def test_tab_base_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::TabSwitcherComponent::TAB_BASE_CLASSES
  end

  def test_tab_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::TabSwitcherComponent.new(tabs: []).tab_classes
  end
end
