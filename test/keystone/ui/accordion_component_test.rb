# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::AccordionComponentTest < Minitest::Test
  def test_returns_base_wrapper_classes
    component = Keystone::Ui::AccordionComponent.new

    assert_equal "flex flex-col gap-4", component.classes
  end

  def test_stores_items_with_question_and_answer
    items = [
      { question: "Q1?", answer: "A1." },
      { question: "Q2?", answer: "A2." }
    ]
    component = Keystone::Ui::AccordionComponent.new(items: items)

    assert_equal items, component.items
  end

  def test_exposes_item_classes
    component = Keystone::Ui::AccordionComponent.new

    assert_includes component.item_classes, "rounded-xl"
    assert_includes component.item_classes, "border"
  end

  def test_exposes_button_classes
    component = Keystone::Ui::AccordionComponent.new

    assert_includes component.button_classes, "flex"
    assert_includes component.button_classes, "w-full"
    assert_includes component.button_classes, "text-left"
  end

  def test_exposes_answer_panel_classes
    component = Keystone::Ui::AccordionComponent.new

    assert_includes component.answer_classes, "hidden"
  end

  def test_uses_semantic_accent_classes_for_button_hover
    component = Keystone::Ui::AccordionComponent.new

    assert_includes component.button_classes, "hover:text-accent-600"
    assert_includes component.button_classes, "dark:hover:text-accent-400"
  end

  def test_uses_semantic_surface_classes
    component = Keystone::Ui::AccordionComponent.new

    assert_includes component.item_classes, "border-surface-200"
    assert_includes component.item_classes, "dark:border-surface-700"
    assert_includes component.button_classes, "text-surface-900"
    assert_includes component.answer_classes, "text-surface-600"
    assert_includes component.icon_classes, "text-surface-400"
  end

  def test_wires_the_accordion_stimulus_controller
    component = Keystone::Ui::AccordionComponent.new

    assert_equal "accordion", component.wrapper_data[:controller]
  end
end
