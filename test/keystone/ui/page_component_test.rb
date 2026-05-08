# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::PageComponentTest < Minitest::Test
  def test_includes_responsive_horizontal_padding_by_default
    component = Keystone::Ui::PageComponent.new

    assert_includes component.classes, "px-4"
    assert_includes component.classes, "sm:px-6"
    assert_includes component.classes, "lg:px-8"
  end

  def test_includes_vertical_padding_by_default
    component = Keystone::Ui::PageComponent.new

    assert_includes component.classes, "py-4"
  end

  def test_omits_padding_when_padding_none
    component = Keystone::Ui::PageComponent.new(padding: :none)

    refute_includes component.classes, "px-4"
  end

  def test_maps_each_max_width_value_to_the_correct_tailwind_class
    assert_includes Keystone::Ui::PageComponent.new(max_width: :sm).classes, "max-w-2xl"
    assert_includes Keystone::Ui::PageComponent.new(max_width: :md).classes, "max-w-4xl"
    assert_includes Keystone::Ui::PageComponent.new(max_width: :lg).classes, "max-w-6xl"
    assert_includes Keystone::Ui::PageComponent.new(max_width: :xl).classes, "max-w-7xl"
  end

  def test_adds_mx_auto_for_centering_when_max_width_is_not_full
    component = Keystone::Ui::PageComponent.new(max_width: :md)

    assert_includes component.classes, "mx-auto"
  end

  def test_does_not_add_mx_auto_when_max_width_is_full
    component = Keystone::Ui::PageComponent.new(max_width: :full)

    refute_includes component.classes, "mx-auto"
  end

  def test_does_not_include_top_offset_by_default
    component = Keystone::Ui::PageComponent.new

    refute_match(/pt-\d+/, component.classes)
  end

  def test_maps_each_top_offset_value_to_the_correct_tailwind_class
    assert_includes Keystone::Ui::PageComponent.new(top_offset: :sm).classes, "pt-12"
    assert_includes Keystone::Ui::PageComponent.new(top_offset: :md).classes, "pt-16"
    assert_includes Keystone::Ui::PageComponent.new(top_offset: :lg).classes, "pt-20"
    assert_includes Keystone::Ui::PageComponent.new(top_offset: :xl).classes, "pt-24"
  end
end
