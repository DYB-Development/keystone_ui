# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::TabSwitcherComponentTest < Minitest::Test
  def test_returns_base_wrapper_classes
    component = Keystone::Ui::TabSwitcherComponent.new(tabs: [ "One", "Two" ])

    assert_equal "mb-8 flex flex-wrap justify-center gap-2", component.classes
  end

  def test_stores_tab_labels
    component = Keystone::Ui::TabSwitcherComponent.new(tabs: [ "Alpha", "Beta", "Gamma" ])

    assert_equal [ "Alpha", "Beta", "Gamma" ], component.tabs
  end

  def test_exposes_tab_button_classes
    component = Keystone::Ui::TabSwitcherComponent.new(tabs: [ "A" ])

    assert_includes component.tab_classes, "rounded-lg"
    assert_includes component.tab_classes, "font-semibold"
  end

  def test_uses_semantic_accent_classes_for_active_tab_state
    component = Keystone::Ui::TabSwitcherComponent.new(tabs: [ "A" ])

    assert_includes component.tab_classes, "data-[active]:bg-accent-500/10"
    assert_includes component.tab_classes, "data-[active]:text-accent-600"
  end

  def test_exposes_panel_classes_as_hidden
    component = Keystone::Ui::TabSwitcherComponent.new(tabs: [ "A" ])

    assert_equal "hidden", component.panel_classes
  end

  def test_includes_dark_mode_accent_classes_for_active_tab
    component = Keystone::Ui::TabSwitcherComponent.new(tabs: [ "A" ])

    assert_includes component.tab_classes, "dark:data-[active]:text-accent-400"
  end

  def test_wires_the_tab_switcher_stimulus_controller
    component = Keystone::Ui::TabSwitcherComponent.new(tabs: [ "A", "B" ])

    assert_equal "tab-switcher", component.wrapper_data[:controller]
  end
end
