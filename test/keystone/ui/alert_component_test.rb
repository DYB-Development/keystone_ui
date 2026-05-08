# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::AlertComponentTest < Minitest::Test
  def test_returns_info_classes_by_default
    component = Keystone::Ui::AlertComponent.new(message: "FYI")

    assert_includes component.classes, "bg-accent-50"
    assert_includes component.classes, "text-accent-800"
  end

  def test_maps_each_type_to_its_variant_classes
    %i[success warning error].each do |type|
      component = Keystone::Ui::AlertComponent.new(message: "msg", type: type)
      assert_includes component.classes, Keystone::Ui::AlertComponent::TYPE_CLASSES[type]
    end
  end

  def test_exposes_message_text
    component = Keystone::Ui::AlertComponent.new(message: "Item saved!")

    assert_equal "Item saved!", component.message_text
  end

  def test_exposes_title_when_provided
    component = Keystone::Ui::AlertComponent.new(message: "Could not save", title: "Error")

    assert_equal true, component.title?
    assert_equal "Error", component.title_text
  end

  def test_returns_false_for_title_when_not_provided
    component = Keystone::Ui::AlertComponent.new(message: "FYI")

    assert_equal false, component.title?
  end

  def test_exposes_dismissible_flag
    assert_equal true, Keystone::Ui::AlertComponent.new(message: "x", dismissible: true).dismissible?
    assert_equal false, Keystone::Ui::AlertComponent.new(message: "x").dismissible?
  end

  def test_uses_semantic_accent_classes_for_info_type
    component = Keystone::Ui::AlertComponent.new(message: "FYI", type: :info)

    assert_includes component.classes, "bg-accent-50"
    assert_includes component.classes, "text-accent-800"
    assert_includes component.classes, "dark:bg-accent-900/30"
    assert_includes component.classes, "dark:text-accent-300"
  end

  def test_provides_stimulus_controller_data_for_dismissible_alerts
    component = Keystone::Ui::AlertComponent.new(message: "x", dismissible: true)

    assert_equal "dismiss", component.wrapper_data[:controller]
  end
end
