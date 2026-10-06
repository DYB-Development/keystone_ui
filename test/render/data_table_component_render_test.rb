# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::DataTableComponentRenderTest < ViewComponent::TestCase
  def setup
    KeystoneUi.reset_configuration!
  end

  def teardown
    KeystoneUi.reset_configuration!
  end

  def test_given_a_key_hides_the_hideable_columns_its_saved_value_names
    KeystoneUi.configure { |c| c.preference_supplier = ->(_view, _key) { { value: { "hidden_columns" => [ "pipeline" ] } } } }

    columns = month_columns
    page = render_in_view_context do
      ui_data_table(items: [ { month: "Jan", pipeline: "$10" } ], columns: columns, key: :months)
    end

    assert_equal [ "Month" ], page.css("thead th").map { |header| header.text.strip }
  end

  def test_given_a_key_with_nothing_saved_hides_the_columns_its_own_call_hides
    KeystoneUi.configure { |c| c.preference_supplier = ->(_view, _key) { nil } }

    columns = month_columns
    page = render_in_view_context do
      ui_data_table(items: [ { month: "Jan", pipeline: "$10" } ], columns: columns, key: :months, hidden_columns: [ :pipeline ])
    end

    assert_equal [ "Month" ], page.css("thead th").map { |header| header.text.strip }
  end

  def test_given_a_save_address_shows_a_columns_menu_that_saves_to_it
    KeystoneUi.configure { |c| c.preference_supplier = ->(_view, _key) { { value: {}, save_url: "/preferences/months" } } }

    columns = month_columns
    page = render_in_view_context do
      ui_data_table(items: [ { month: "Jan", pipeline: "$10" } ], columns: columns, key: :months)
    end

    assert_equal [ "/preferences/months" ], page.css("[data-controller=column-picker]").map { |picker| picker["data-column-picker-save-url-value"] }
  end

  def test_given_no_save_address_shows_no_columns_menu
    KeystoneUi.configure { |c| c.preference_supplier = ->(_view, _key) { { value: {} } } }

    columns = month_columns
    page = render_in_view_context do
      ui_data_table(items: [ { month: "Jan", pipeline: "$10" } ], columns: columns, key: :months)
    end

    assert_empty page.css("[data-controller=column-picker]")
  end

  def test_given_a_key_and_no_lookup_configured_hides_the_columns_its_own_call_hides
    columns = month_columns
    page = render_in_view_context do
      ui_data_table(items: [ { month: "Jan", pipeline: "$10" } ], columns: columns, key: :months, hidden_columns: [ :pipeline ])
    end

    assert_equal [ "Month" ], page.css("thead th").map { |header| header.text.strip }
  end

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

  private

  def month_columns
    [ Keystone::Ui::Column.new(:month, "Month"), Keystone::Ui::Column.new(:pipeline, "Pipeline", hideable: true) ]
  end
end
