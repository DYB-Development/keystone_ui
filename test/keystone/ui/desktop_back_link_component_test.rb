# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::DesktopBackLinkComponentTest < Minitest::Test
  def test_exposes_url
    component = Keystone::Ui::DesktopBackLinkComponent.new(url: "/invoices")

    assert_equal "/invoices", component.instance_variable_get(:@url)
  end

  def test_is_shown_only_from_large_screens_where_the_mobile_header_is_hidden
    assert_includes Keystone::Ui::DesktopBackLinkComponent::CLASSES.split, "lg:inline-flex"
  end

  def test_renders_the_same_ks_class_as_the_mobile_back_link
    assert_includes Keystone::Ui::DesktopBackLinkComponent::CLASSES.split, "ks-mobile-header-back"
  end

  def test_renders_the_ks_class_that_spaces_it_from_the_page_content
    assert_includes Keystone::Ui::DesktopBackLinkComponent::CLASSES.split, "ks-page-back"
  end

  def test_is_labelled_back
    assert_equal "Back", Keystone::Ui::DesktopBackLinkComponent::LABEL
  end
end
