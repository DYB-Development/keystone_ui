# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::ActionMenuComponentRenderTest < ViewComponent::TestCase
  def test_shows_its_items_in_a_dropdown_opened_by_an_actions_button
    page = render_inline(Keystone::Ui::ActionMenuComponent.new) { "<a href=\"/edit\">Edit</a>".html_safe }

    assert_equal [ "/edit" ], page.css("[data-controller=dropdown] button[aria-label=Actions] ~ [data-dropdown-target=menu] a").map { |link| link["href"] }
  end
end
