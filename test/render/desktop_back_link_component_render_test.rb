# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::DesktopBackLinkComponentRenderTest < ViewComponent::TestCase
  def test_links_back_to_the_url_it_is_given
    page = render_inline(Keystone::Ui::DesktopBackLinkComponent.new(url: "/invoices"))

    assert_equal "/invoices", page.css("a").attr("href").value
  end
end
