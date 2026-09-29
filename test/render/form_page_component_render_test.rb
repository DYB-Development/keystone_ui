# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::FormPageComponentRenderTest < ViewComponent::TestCase
  def test_renders_the_title_as_the_page_heading
    page = render_inline(Keystone::Ui::FormPageComponent.new(title: "New Invoice", back_url: "/invoices"))

    assert_equal "New Invoice", page.css("h1").text.strip
  end
end
