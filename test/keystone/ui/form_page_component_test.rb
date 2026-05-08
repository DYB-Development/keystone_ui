# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::FormPageComponentTest < Minitest::Test
  def test_exposes_title
    component = Keystone::Ui::FormPageComponent.new(title: "New Invoice", back_url: "/invoices")

    assert_equal "New Invoice", component.instance_variable_get(:@title)
  end

  def test_exposes_back_url
    component = Keystone::Ui::FormPageComponent.new(title: "New Invoice", back_url: "/invoices")

    assert_equal "/invoices", component.instance_variable_get(:@back_url)
  end

  def test_returns_true_for_subtitle_when_subtitle_is_provided
    component = Keystone::Ui::FormPageComponent.new(title: "New Invoice", back_url: "/invoices", subtitle: "Fill in the details")

    assert_equal true, component.subtitle?
  end

  def test_returns_false_for_subtitle_when_subtitle_is_not_provided
    component = Keystone::Ui::FormPageComponent.new(title: "New Invoice", back_url: "/invoices")

    assert_equal false, component.subtitle?
  end

  def test_has_desktop_wrapper_classes_hidden_on_mobile
    assert_includes Keystone::Ui::FormPageComponent::DESKTOP_WRAPPER_CLASSES, "hidden"
    assert_includes Keystone::Ui::FormPageComponent::DESKTOP_WRAPPER_CLASSES, "md:block"
  end

  def test_has_title_classes_constant
    assert_includes Keystone::Ui::FormPageComponent::TITLE_CLASSES, "text-2xl"
    assert_includes Keystone::Ui::FormPageComponent::TITLE_CLASSES, "font-semibold"
  end

  def test_has_subtitle_classes_constant
    assert_includes Keystone::Ui::FormPageComponent::SUBTITLE_CLASSES, "text-sm"
    assert_includes Keystone::Ui::FormPageComponent::SUBTITLE_CLASSES, "text-gray-500"
  end
end
