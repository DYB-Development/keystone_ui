# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::CardLinkComponentTest < Minitest::Test
  def test_includes_block_border_bg_padding_shadow_radius_and_hover_by_default
    component = Keystone::Ui::CardLinkComponent.new(href: "/test")

    classes = component.classes
    assert_includes classes, "block"
    assert_includes classes, "rounded-lg"
    assert_includes classes, "border"
    assert_includes classes, "border-gray-200"
    assert_includes classes, "bg-white"
    assert_includes classes, "p-4"
    assert_includes classes, "shadow-sm"
    assert_includes classes, "hover:border-accent-500/50"
    assert_includes classes, "dark:border-zinc-700"
    assert_includes classes, "dark:bg-zinc-900"
  end

  def test_stores_the_href
    component = Keystone::Ui::CardLinkComponent.new(href: "/people/1")

    assert_equal "/people/1", component.href
  end

  def test_maps_each_padding_size_correctly
    assert_includes Keystone::Ui::CardLinkComponent.new(href: "/", padding: :sm).classes, "p-3"
    assert_includes Keystone::Ui::CardLinkComponent.new(href: "/", padding: :md).classes, "p-4"
    assert_includes Keystone::Ui::CardLinkComponent.new(href: "/", padding: :lg).classes, "p-6"
  end

  def test_omits_shadow_sm_when_shadow_false
    component = Keystone::Ui::CardLinkComponent.new(href: "/", shadow: false)

    refute_includes component.classes, "shadow-sm"
  end

  def test_always_includes_dark_mode_and_hover_classes
    component = Keystone::Ui::CardLinkComponent.new(href: "/")

    assert_includes component.classes, "dark:bg-zinc-900"
    assert_includes component.classes, "dark:border-zinc-700"
    assert_includes component.classes, "hover:border-accent-500/50"
  end
end
