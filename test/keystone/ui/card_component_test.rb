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

  def test_renders_the_shared_card_classes_for_each_form_and_part
    assert_equal "ks-card", Keystone::Ui::CardComponent.new(title: "X", summary: "Y", link: "/z").send(:card_classes)
    assert_equal "ks-card-edge", Keystone::Ui::CardComponent.new(title: "X", summary: "Y", link: "/z", edge_to_edge: true).send(:card_classes)
    assert_equal "ks-card-body", Keystone::Ui::CardComponent::BODY_CLASSES
    assert_equal "ks-card-title", Keystone::Ui::CardComponent::TITLE_CLASSES
    assert_equal "ks-card-summary", Keystone::Ui::CardComponent::SUMMARY_CLASSES
    assert_equal "ks-card-cta", Keystone::Ui::CardComponent::CTA_CLASSES
    assert_equal "ks-card-link", Keystone::Ui::CardComponent.new(title: "X", summary: "Y", link: "/z").link_classes
  end

  def test_adds_the_classes_passed_for_one_use
    assert_equal "ks-card shadow-lg", Keystone::Ui::CardComponent.new(title: "X", summary: "Y", link: "/z", class: "shadow-lg").send(:card_classes)
  end
end
