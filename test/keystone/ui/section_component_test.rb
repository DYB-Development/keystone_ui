# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::SectionComponentTest < Minitest::Test
  def test_returns_true_for_header_when_title_is_present
    component = Keystone::Ui::SectionComponent.new(title: "Users")

    assert_equal true, component.header?
  end

  def test_returns_false_for_header_when_title_is_nil
    component = Keystone::Ui::SectionComponent.new

    assert_equal false, component.header?
  end

  def test_stores_the_action_hash
    action = { label: "View all", href: "/users" }
    component = Keystone::Ui::SectionComponent.new(title: "Users", action: action)

    assert_equal action, component.instance_variable_get(:@action)
  end

  def test_renders_the_shared_section_classes_for_each_spacing_and_part
    assert_equal "ks-section-md", Keystone::Ui::SectionComponent.new.spacing_class
    assert_equal "ks-section-sm", Keystone::Ui::SectionComponent.new(spacing: :sm).spacing_class
    assert_equal "ks-section-lg", Keystone::Ui::SectionComponent.new(spacing: :lg).spacing_class
    assert_equal "ks-section-header", Keystone::Ui::SectionComponent::HEADER_CLASSES
    assert_equal "ks-section-title", Keystone::Ui::SectionComponent::TITLE_CLASSES
    assert_equal "ks-section-subtitle", Keystone::Ui::SectionComponent::SUBTITLE_CLASSES
    assert_equal "ks-section-action", Keystone::Ui::SectionComponent.new(title: "Users").action_classes
  end

  def test_adds_the_classes_passed_for_one_use
    assert_equal "ks-section-md px-2", Keystone::Ui::SectionComponent.new(class: "px-2").classes
  end
end
