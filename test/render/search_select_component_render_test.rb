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

  def test_a_search_dropdown_opened_with_a_record_chosen_shows_that_record_and_submits_its_id
    page = render_inline(Keystone::Ui::SearchSelectComponent.new(name: "space[address_id]", label: "Address", url: "/addresses/matches", selected_id: 7, selected_label: "9 Dock Rd, Springfield"))

    assert_equal [ "7", "9 Dock Rd, Springfield" ], [ page.at_css("input[data-search-select-target=id]")["value"], page.at_css("input[data-search-select-target=input]")["value"] ]
  end

  def test_fields_for_a_new_record_are_drawn_hidden_inside_the_search_dropdown
    page = render_inline(Keystone::Ui::SearchSelectComponent.new(name: "space[address_id]", label: "Address", url: "/addresses/matches", new_label: "Enter a new address")) { "<input name=\"address[line1]\">".html_safe }

    assert_equal [ "address[line1]", true ], [ page.at_css("[data-search-select-target=newFields] input")["name"], page.at_css("[data-search-select-target=newFields]")["class"].split.include?("hidden") ]
  end
end
