# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::FormPageComponentRenderTest < ViewComponent::TestCase
  def test_renders_the_title_as_the_page_heading
    page = render_inline(Keystone::Ui::FormPageComponent.new(title: "New Invoice", back_url: "/invoices"))

    assert_equal "New Invoice", page.css("h1").text.strip
  end

  def test_shows_a_desktop_link_back_to_the_back_url
    page = render_inline(Keystone::Ui::FormPageComponent.new(title: "New Invoice", back_url: "/invoices"))

    assert_equal "/invoices", page.css("a.lg\\:inline-flex").attr("href")&.value
  end

  def test_given_a_trail_shows_breadcrumbs_ending_with_the_title
    page = render_inline(Keystone::Ui::FormPageComponent.new(title: "New Invoice", back_url: "/invoices", trail: [ [ "Invoices", "/invoices" ] ]))

    assert_equal "New Invoice", page.css("nav[aria-label=Breadcrumb] [aria-current=page]").text.strip
  end
end
