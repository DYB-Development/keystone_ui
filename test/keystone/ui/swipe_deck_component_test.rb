# frozen_string_literal: true

require "ostruct"
require "test_helper"
require_relative "../../../app/components/keystone/ui/swipe_deck_component"

class Keystone::Ui::SwipeDeckComponentTest < Minitest::Test
  VISUAL_UTILITY = %r{(?:^|\s)(?:[\w\-\[\]&]+:)*(?:bg-|text-(?!xs\b|sm\b|base\b|lg\b|xl\b|\dxl\b|left\b|center\b|right\b)|border|rounded|shadow|ring|font-(?!mono\b)|p[xytblr]?-|m[xytblr]?-(?!auto\b)|gap-|space-[xy]-|divide-)}

  def items
    @items ||= [
      OpenStruct.new(id: 1, name: "Meditate"),
      OpenStruct.new(id: 2, name: "Exercise"),
      OpenStruct.new(id: 3, name: "Read")
    ]
  end

  def test_card_data_returns_items_with_z_index_and_transform_for_stacked_appearance
    component = Keystone::Ui::SwipeDeckComponent.new(items: items)
    data = component.card_data

    assert_equal 3, data.length
    assert_equal({ item: items[0], index: 0, z_index: 3, transform: "scale(1.0) translateY(0px)" }, data[0])
    assert_equal({ item: items[1], index: 1, z_index: 2, transform: "scale(0.95) translateY(8px)" }, data[1])
    assert_equal({ item: items[2], index: 2, z_index: 1, transform: "scale(0.9) translateY(16px)" }, data[2])
  end

  def test_empty_returns_true_when_items_are_empty
    component = Keystone::Ui::SwipeDeckComponent.new(items: [])
    assert_equal true, component.empty?
  end

  def test_empty_returns_false_when_items_are_present
    component = Keystone::Ui::SwipeDeckComponent.new(items: items)
    assert_equal false, component.empty?
  end

  def test_defaults_has_default_empty_title
    component = Keystone::Ui::SwipeDeckComponent.new(items: [])
    assert_equal "All done!", component.instance_variable_get(:@empty_title)
  end

  def test_defaults_has_nil_empty_subtitle_by_default
    component = Keystone::Ui::SwipeDeckComponent.new(items: [])
    assert_nil component.instance_variable_get(:@empty_subtitle)
  end

  def test_defaults_accepts_custom_empty_title_and_empty_subtitle
    component = Keystone::Ui::SwipeDeckComponent.new(items: [], empty_title: "Finished!", empty_subtitle: "Nothing left.")
    assert_equal "Finished!", component.instance_variable_get(:@empty_title)
    assert_equal "Nothing left.", component.instance_variable_get(:@empty_subtitle)
  end

  def test_item_stores_the_item_block
    component = Keystone::Ui::SwipeDeckComponent.new(items: items)
    block = proc { |item| "Render #{item.name}" }
    component.item(&block)
    assert_equal block, component.instance_variable_get(:@item_block)
  end

  def test_item_before_render_evaluates_content_block_so_item_block_is_registered
    component = Keystone::Ui::SwipeDeckComponent.new(items: items)
    component.set_content_block do |deck|
      deck.item { |item| "Render #{item.name}" }
    end

    assert_nil component.instance_variable_get(:@item_block)
    component.before_render
    refute_nil component.instance_variable_get(:@item_block)
  end

  def test_item_id_returns_item_id_when_item_responds_to_id
    component = Keystone::Ui::SwipeDeckComponent.new(items: items)
    assert_equal 1, component.item_id(items[0])
  end

  def test_item_id_falls_back_to_index_when_item_does_not_respond_to_id
    hash_item = { name: "Hash item" }
    component = Keystone::Ui::SwipeDeckComponent.new(items: [ hash_item ])
    assert_equal 0, component.item_id(hash_item, fallback_index: 0)
  end

  def test_card_classes_render_the_ks_swipe_card_class
    assert_includes Keystone::Ui::SwipeDeckComponent::CARD_CLASSES, "ks-swipe-card"
  end

  def test_card_classes_hold_no_visual_utility
    refute_match VISUAL_UTILITY, Keystone::Ui::SwipeDeckComponent::CARD_CLASSES
  end

  def test_empty_classes_render_the_ks_swipe_empty_class
    assert_includes Keystone::Ui::SwipeDeckComponent::EMPTY_CLASSES, "ks-swipe-empty"
  end
end
