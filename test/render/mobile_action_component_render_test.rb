# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::MobileActionComponentRenderTest < ViewComponent::TestCase
  def test_links_to_the_address_a_page_header_publishes
    page = render_after_page_header(title: "Events", action_url: "/events/new", action_label: "Create")

    assert_equal "/events/new", top_bar_link(page)&.[]("href")
  end

  private

  def render_after_page_header(**header)
    render_in_view_context do
      safe_join([ render(Keystone::Ui::PageHeaderComponent.new(**header)), render(Keystone::Ui::MobileActionComponent.new) ])
    end
  end

  def top_bar_link(page)
    page.css("a").find { |link| !link.ancestors(".ks-page-header").any? }
  end
end
