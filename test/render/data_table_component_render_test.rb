# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::DataTableComponentRenderTest < ViewComponent::TestCase
  def test_puts_each_row_s_actions_in_an_action_menu
    page = render_in_view_context do
      ui_data_table(items: [ { name: "Lawn mow" } ], columns: [ { name: "Name" } ]) do |table|
        table.actions { |row| ui_action_menu_item(label: "Edit", href: "/products/1/edit") }
      end
    end

    assert_equal [ "/products/1/edit" ], page.css("tbody [data-action-menu-target=menu] a.ks-menu-option").map { |link| link["href"] }
  end
  def test_shows_no_action_menu_on_a_row_whose_actions_are_empty
    page = render_in_view_context do
      ui_data_table(items: [ { name: "Lawn mow" }, { name: "Edging" } ], columns: [ { name: "Name" } ]) do |table|
        table.actions { |row| ui_action_menu_item(label: "Edit", href: "/products/1/edit") if row[:name] == "Lawn mow" }
      end
    end

    assert_equal [ 1, 0 ], page.css("tbody tr").map { |row| row.css("[data-controller=action-menu]").size }
  end
end
