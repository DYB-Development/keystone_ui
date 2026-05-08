# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::CardComponentTest < Minitest::Test
  def test_returns_card_classes_by_default
    component = Keystone::Ui::CardComponent.new(title: "Revenue", summary: "$42k", link: "/reports")

    assert_equal Keystone::Ui::CardComponent::CARD_CLASSES, component.send(:card_classes)
  end

  def test_returns_card_edge_classes_when_edge_to_edge_is_true
    component = Keystone::Ui::CardComponent.new(title: "Revenue", summary: "$42k", link: "/reports", edge_to_edge: true)

    assert_equal Keystone::Ui::CardComponent::CARD_EDGE_CLASSES, component.send(:card_classes)
  end

  def test_defaults_cta_to_read_more
    component = Keystone::Ui::CardComponent.new(title: "Revenue", summary: "$42k", link: "/reports")

    assert_equal "Read more", component.instance_variable_get(:@cta)
  end

  def test_accepts_a_custom_cta
    component = Keystone::Ui::CardComponent.new(title: "Revenue", summary: "$42k", link: "/reports", cta: "View details")

    assert_equal "View details", component.instance_variable_get(:@cta)
  end

  def test_uses_semantic_accent_classes_for_link
    component = Keystone::Ui::CardComponent.new(title: "X", summary: "Y", link: "/z")

    assert_includes component.link_classes, "text-accent-600"
    assert_includes component.link_classes, "hover:text-accent-900"
    assert_includes component.link_classes, "dark:text-accent-400"
  end
end
