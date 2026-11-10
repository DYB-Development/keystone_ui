# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::MobileHeaderComponentRenderTest < ViewComponent::TestCase
  def test_given_no_back_url_shows_no_back_link
    page = render_inline(Keystone::Ui::MobileHeaderComponent.new(title: "Invoices", back_url: nil))

    assert_empty page.css("a")
  end

  def test_draws_the_back_arrow_and_title_in_one_row_with_the_pages_side_margin
    page = render_inline(Keystone::Ui::MobileHeaderComponent.new(title: "Invoices", back_url: "/"))

    assert_includes page.at_css(".ks-mobile-header-title").parent["class"].to_s.split, "ks-page"
  end
end
