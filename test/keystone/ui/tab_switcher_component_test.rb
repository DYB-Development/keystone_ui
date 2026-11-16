# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::TabSwitcherComponentTest < Minitest::Test
  VISUAL_UTILITY = %r{(?:^|\s)(?:[\w\-\[\]&]+:)*(?:bg-|text-(?!xs\b|sm\b|base\b|lg\b|xl\b|\dxl\b|left\b|center\b|right\b)|border|rounded|shadow|ring|font-(?!mono\b)|p[xytblr]?-|m[xytblr]?-(?!auto\b)|gap-|space-[xy]-|divide-)}

  def test_returns_base_wrapper_classes
    component = Keystone::Ui::TabSwitcherComponent.new(tabs: [ "One", "Two" ])

    assert_equal "ks-tab-bar flex flex-wrap justify-center max-sm:flex-nowrap max-sm:overflow-x-auto max-sm:justify-start", component.classes
  end

  def test_below_sm_the_tab_row_stays_on_one_line_and_scrolls_sideways
    component = Keystone::Ui::TabSwitcherComponent.new(tabs: [ "One", "Two" ])

    assert_equal %w[max-sm:flex-nowrap max-sm:overflow-x-auto], component.classes.split & %w[max-sm:flex-nowrap max-sm:overflow-x-auto]
  end

  def test_below_sm_the_tab_row_starts_at_the_left_edge
    component = Keystone::Ui::TabSwitcherComponent.new(tabs: [ "One", "Two" ])

    assert_includes component.classes.split, "max-sm:justify-start"
  end

  def test_aligned_to_the_start_the_tab_row_starts_at_the_left_edge_on_every_width
    component = Keystone::Ui::TabSwitcherComponent.new(tabs: [ "One", "Two" ], align: :start)

    assert_equal %w[justify-start], component.classes.split.grep_v(/\Amax-sm:/) & %w[justify-start justify-center]
  end

  def test_aligned_to_the_start_the_tab_row_still_stays_on_one_line_and_scrolls_sideways_below_sm
    component = Keystone::Ui::TabSwitcherComponent.new(tabs: [ "One", "Two" ], align: :start)

    assert_equal %w[max-sm:flex-nowrap max-sm:overflow-x-auto], component.classes.split & %w[max-sm:flex-nowrap max-sm:overflow-x-auto]
  end

  def test_shaped_as_pills_the_tab_row_carries_the_pill_row_class
    component = Keystone::Ui::TabSwitcherComponent.new(tabs: [ "One", "Two" ], shape: :pills)

    assert_includes component.classes.split, "ks-tab-bar-pills"
  end

  def test_shaped_as_underlined_tabs_the_tab_row_carries_the_underlined_row_class
    component = Keystone::Ui::TabSwitcherComponent.new(tabs: [ "One", "Two" ], shape: :underline)

    assert_includes component.classes.split, "ks-tab-bar-underline"
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

  def test_uses_semantic_accent_classes_for_active_tab_state
    component = Keystone::Ui::TabSwitcherComponent.new(tabs: [ "A" ])

    assert_includes component.tab_classes, "ks-tab-active"
  end
end
