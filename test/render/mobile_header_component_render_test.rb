# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::MobileHeaderComponentRenderTest < ViewComponent::TestCase
  def test_given_no_back_url_shows_no_back_link
    page = render_inline(Keystone::Ui::MobileHeaderComponent.new(title: "Invoices", back_url: nil))

    assert_empty page.css("a")
  end
end
