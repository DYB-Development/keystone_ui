# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::ShowPageComponentRenderTest < ViewComponent::TestCase
  def test_shows_a_desktop_link_back_to_the_back_url
    page = render_inline(Keystone::Ui::ShowPageComponent.new(title: "Invoice #42", back_url: "/invoices"))

    assert_equal "/invoices", page.css("a.lg\\:inline-flex").attr("href")&.value
  end
end
