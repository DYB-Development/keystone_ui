# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::MobileActionComponentRenderTest < ViewComponent::TestCase
  def test_links_to_the_address_a_page_header_publishes
    render_inline(Keystone::Ui::PageHeaderComponent.new(title: "Events", action_url: "/events/new", action_label: "Create"))

    page = render_inline(Keystone::Ui::MobileActionComponent.new)

    assert_equal "/events/new", page.at_css("a")&.[]("href")
  end
end
