# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::PageHeaderComponentRenderTest < ViewComponent::TestCase
  def test_given_only_an_action_address_draws_it_as_a_button
    page = render_inline(Keystone::Ui::PageHeaderComponent.new(title: "Events", action_url: "/events/new", action_label: "Create"))

    assert_equal "Create", page.at_css(".ks-page-header-actions a[href='/events/new']")&.text
  end
end
