# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::PanelComponentTest < Minitest::Test
  def test_includes_border_bg_padding_shadow_and_radius_by_default
    component = Keystone::Ui::PanelComponent.new

    classes = component.classes
    assert_includes classes, "ks-panel-radius-lg"
    assert_includes classes, "ks-panel"
    assert_includes classes, "ks-panel-padding-md"
    assert_includes classes, "ks-panel-shadow"
  end

  def test_maps_each_padding_size_correctly
    assert_includes Keystone::Ui::PanelComponent.new(padding: :sm).classes, "ks-panel-padding-sm"
    assert_includes Keystone::Ui::PanelComponent.new(padding: :md).classes, "ks-panel-padding-md"
    assert_includes Keystone::Ui::PanelComponent.new(padding: :lg).classes, "ks-panel-padding-lg"
  end

  def test_maps_each_radius_size_correctly
    assert_includes Keystone::Ui::PanelComponent.new(radius: :md).classes, "ks-panel-radius-md"
    assert_includes Keystone::Ui::PanelComponent.new(radius: :lg).classes, "ks-panel-radius-lg"
    assert_includes Keystone::Ui::PanelComponent.new(radius: :xl).classes, "ks-panel-radius-xl"
  end

  def test_omits_shadow_sm_when_shadow_false
    component = Keystone::Ui::PanelComponent.new(shadow: false)

    refute_includes component.classes, "ks-panel-shadow"
  end
end
