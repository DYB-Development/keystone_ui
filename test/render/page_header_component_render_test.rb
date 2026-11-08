# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::PageHeaderComponentRenderTest < ViewComponent::TestCase
  def test_given_only_an_action_address_draws_it_as_a_button
    page = render_inline(Keystone::Ui::PageHeaderComponent.new(title: "Events", action_url: "/events/new", action_label: "Create"))

    assert_equal "Create", page.at_css(".ks-page-header-actions a[href='/events/new']")&.text
  end

  def test_given_an_action_method_posts_the_button_to_the_action_address
    page = render_inline(Keystone::Ui::PageHeaderComponent.new(title: "Events", action_url: "/events", action_label: "Create", action_method: :post))

    assert_equal "post", page.at_css(".ks-page-header-actions form[action='/events']")&.[]("method")
  end

  def test_given_an_action_method_passes_it_to_the_layout
    method = render_in_view_context do
      ui_page_header(title: "Events", action_url: "/events", action_method: :post)
      content_for(:mobile_action_method)
    end

    assert_equal "post", method.text.strip
  end

  def test_given_an_action_block_draws_only_the_block
    page = render_inline(Keystone::Ui::PageHeaderComponent.new(title: "Events", action_url: "/events/new")) do |header|
      header.action { "Block" }
    end

    assert_equal [ "Block" ], page.css(".ks-page-header-actions").map { |actions| actions.text.strip }
  end

  def test_given_a_title_passes_it_to_the_layout
    title = render_in_view_context do
      ui_page_header(title: "Events")
      content_for(:mobile_page_title)
    end

    assert_equal "Events", title.text.strip
  end

  def test_given_no_title_passes_none_to_the_layout
    title_set = nil
    render_in_view_context do
      ui_page_header(title: nil)
      title_set = content_for?(:mobile_page_title)
      nil
    end

    assert_equal false, title_set
  end
end
