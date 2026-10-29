# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::SearchSelectComponentRenderTest < ViewComponent::TestCase
  def test_a_view_draws_a_search_dropdown_that_fetches_its_matches_from_the_host_and_submits_the_named_id
    page = render_in_view_context do
      ui_search_select(name: "space[address_id]", label: "Address", url: "/addresses/matches")
    end

    assert_equal [ "/addresses/matches", "space[address_id]" ],
      [ page.at_css("[data-controller=search-select]")["data-search-select-url-value"], page.at_css("input[type=hidden][data-search-select-target=id]")["name"] ]
  end
end
