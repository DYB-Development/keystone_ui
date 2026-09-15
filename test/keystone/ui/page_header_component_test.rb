# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::PageHeaderComponentTest < Minitest::Test
  def test_exposes_title
    component = Keystone::Ui::PageHeaderComponent.new(title: "Shopping Lists")

    assert_equal "Shopping Lists", component.title
  end

  def test_exposes_subtitle_when_provided
    component = Keystone::Ui::PageHeaderComponent.new(title: "Lists", subtitle: "Manage your lists")

    assert_equal true, component.subtitle?
    assert_equal "Manage your lists", component.subtitle_text
  end

  def test_returns_false_for_subtitle_when_not_provided
    component = Keystone::Ui::PageHeaderComponent.new(title: "Lists")

    assert_equal false, component.subtitle?
  end

  def test_registers_an_action_block_via_before_render
    component = Keystone::Ui::PageHeaderComponent.new(title: "Lists")
    component.set_content_block do |header|
      header.action { "New List" }
    end

    assert_equal false, component.action?
    component.before_render
    assert_equal true, component.action?
  end

  def test_exposes_action_url_when_provided
    component = Keystone::Ui::PageHeaderComponent.new(title: "Lists", action_url: "/lists/new")

    assert_equal "/lists/new", component.action_url
  end

  def test_defaults_action_label_to_add_new
    component = Keystone::Ui::PageHeaderComponent.new(title: "Lists", action_url: "/lists/new")

    assert_equal "Add new", component.action_label
  end

  def test_accepts_custom_action_label
    component = Keystone::Ui::PageHeaderComponent.new(title: "Lists", action_url: "/lists/new", action_label: "New list")

    assert_equal "New list", component.action_label
  end

  def test_returns_nil_for_action_url_when_not_provided
    component = Keystone::Ui::PageHeaderComponent.new(title: "Lists")

    assert_nil component.action_url
  end

  def test_renders_the_shared_page_header_classes_for_each_part
    assert_equal "ks-page-header", Keystone::Ui::PageHeaderComponent::WRAPPER_CLASSES
    assert_equal "ks-page-header-title", Keystone::Ui::PageHeaderComponent::TITLE_CLASSES
    assert_equal "ks-page-header-subtitle", Keystone::Ui::PageHeaderComponent::SUBTITLE_CLASSES
    assert_equal "page-header-actions ks-page-header-actions", Keystone::Ui::PageHeaderComponent::ACTIONS_CLASSES
  end

  def test_adds_the_classes_passed_for_one_use
    assert_equal "ks-page-header mb-2", Keystone::Ui::PageHeaderComponent.new(title: "X", class: "mb-2").wrapper_classes
  end
end
