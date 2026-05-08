# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::PanelComponentTest < Minitest::Test
  def test_includes_border_bg_padding_shadow_and_radius_by_default
    component = Keystone::Ui::PanelComponent.new

    classes = component.classes
    assert_includes classes, "rounded-xl"
    assert_includes classes, "border"
    assert_includes classes, "border-gray-200"
    assert_includes classes, "bg-white"
    assert_includes classes, "p-5"
    assert_includes classes, "shadow-sm"
    assert_includes classes, "dark:bg-zinc-900"
    assert_includes classes, "dark:border-zinc-700"
  end

  def test_maps_each_padding_size_correctly
    assert_includes Keystone::Ui::PanelComponent.new(padding: :sm).classes, "p-4"
    assert_includes Keystone::Ui::PanelComponent.new(padding: :md).classes, "p-5"
    assert_includes Keystone::Ui::PanelComponent.new(padding: :lg).classes, "p-6"
  end

  def test_maps_each_radius_size_correctly
    assert_includes Keystone::Ui::PanelComponent.new(radius: :md).classes, "rounded-lg"
    assert_includes Keystone::Ui::PanelComponent.new(radius: :lg).classes, "rounded-xl"
    assert_includes Keystone::Ui::PanelComponent.new(radius: :xl).classes, "rounded-2xl"
  end

  def test_omits_shadow_sm_when_shadow_false
    component = Keystone::Ui::PanelComponent.new(shadow: false)

    refute_includes component.classes, "shadow-sm"
  end

  def test_always_includes_dark_mode_classes
    component = Keystone::Ui::PanelComponent.new

    assert_includes component.classes, "dark:bg-zinc-900"
    assert_includes component.classes, "dark:border-zinc-700"
  end
end
