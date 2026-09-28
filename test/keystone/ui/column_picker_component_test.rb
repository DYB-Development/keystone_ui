# frozen_string_literal: true

require "test_helper"
require_relative "../../../app/components/keystone/ui/column"
require_relative "../../../app/components/keystone/ui/column_picker_component"

class Keystone::Ui::ColumnPickerComponentTest < Minitest::Test
  VISUAL_UTILITY = %r{(?:^|\s)(?:[\w\-\[\]&]+:)*(?:bg-|text-(?!xs\b|sm\b|base\b|lg\b|xl\b|\dxl\b|left\b|center\b|right\b)|border|rounded|shadow|ring|font-(?!mono\b)|p[xytblr]?-|m[xytblr]?-(?!auto\b)|gap-|space-[xy]-|divide-)}

  def columns
    @columns ||= [
      Keystone::Ui::Column.new(:name, "Name"),
      Keystone::Ui::Column.new(:quantity, "Quantity", hideable: true),
      Keystone::Ui::Column.new(:price, "Price", hideable: true)
    ]
  end

  def test_hideable_columns_returns_only_columns_marked_as_hideable
    component = Keystone::Ui::ColumnPickerComponent.new(columns: columns)

    assert_equal [ :quantity, :price ], component.hideable_columns.map(&:key)
  end

  def test_hidden_returns_true_for_columns_in_hidden_columns_list
    component = Keystone::Ui::ColumnPickerComponent.new(columns: columns, hidden_columns: [ :quantity ])

    assert_equal true, component.hidden?(:quantity)
    assert_equal false, component.hidden?(:price)
  end

  def test_hidden_handles_string_keys
    component = Keystone::Ui::ColumnPickerComponent.new(columns: columns, hidden_columns: [ "quantity" ])

    assert_equal true, component.hidden?(:quantity)
  end

  def test_initialization_defaults_hidden_columns_to_empty
    component = Keystone::Ui::ColumnPickerComponent.new(columns: columns)

    assert_equal false, component.hidden?(:quantity)
  end

  def test_initialization_accepts_save_url
    component = Keystone::Ui::ColumnPickerComponent.new(columns: columns, save_url: "/prefs")

    assert_equal "/prefs", component.save_url
  end

  def test_trigger_classes_render_the_ks_menu_trigger_class
    assert_includes Keystone::Ui::ColumnPickerComponent::TRIGGER_CLASSES, "ks-menu-trigger"
  end

  def test_trigger_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::ColumnPickerComponent::TRIGGER_CLASSES
  end

  def test_menu_classes_render_the_ks_menu_class
    assert_includes Keystone::Ui::ColumnPickerComponent::MENU_CLASSES, "ks-menu"
  end

  def test_menu_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::ColumnPickerComponent::MENU_CLASSES
  end
end
