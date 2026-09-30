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
end
