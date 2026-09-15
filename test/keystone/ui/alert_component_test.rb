# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::AlertComponentTest < Minitest::Test
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

  def test_provides_stimulus_controller_data_for_dismissible_alerts
    component = Keystone::Ui::AlertComponent.new(message: "x", dismissible: true)

    assert_equal "dismiss", component.wrapper_data[:controller]
  end

  def test_renders_the_shared_alert_classes_for_each_type_and_part
    assert_equal "ks-alert ks-alert-info", Keystone::Ui::AlertComponent.new(message: "x").classes
    %i[info success warning error].each do |type|
      assert_equal "ks-alert ks-alert-#{type}", Keystone::Ui::AlertComponent.new(message: "x", type: type).classes
    end
    assert_equal "ks-alert-body", Keystone::Ui::AlertComponent::OUTER_CLASSES
    assert_equal "ks-alert-content", Keystone::Ui::AlertComponent::INNER_CLASSES
    assert_equal "ks-alert-title", Keystone::Ui::AlertComponent::TITLE_CLASSES
    assert_equal "ks-alert-message", Keystone::Ui::AlertComponent::MESSAGE_CLASSES
    assert_equal "ks-alert-message-titled", Keystone::Ui::AlertComponent::MESSAGE_WITH_TITLE_CLASSES
    assert_equal "ks-alert-dismiss", Keystone::Ui::AlertComponent::DISMISS_CLASSES
  end
end
