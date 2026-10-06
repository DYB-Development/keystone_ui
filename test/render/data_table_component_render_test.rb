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

  def test_given_no_key_does_not_ask_the_lookup_for_a_saved_value
    KeystoneUi.configure { |c| c.preference_supplier = ->(_view, _key) { { value: { "hidden_columns" => [ "pipeline" ] } } } }

    columns = month_columns
    page = render_in_view_context do
      ui_data_table(items: [ { month: "Jan", pipeline: "$10" } ], columns: columns)
    end

    assert_equal [ "Month", "Pipeline" ], page.css("thead th").map { |header| header.text.strip }
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

  def test_given_a_save_address_and_no_saved_value_hides_the_columns_its_own_call_hides
    KeystoneUi.configure { |c| c.preference_supplier = ->(_view, _key) { { value: nil, save_url: "/preferences/months" } } }

    columns = month_columns
    page = render_in_view_context do
      ui_data_table(items: [ { month: "Jan", pipeline: "$10" } ], columns: columns, key: :months, hidden_columns: [ :pipeline ])
    end

    assert_equal [ "Month" ], page.css("thead th").map { |header| header.text.strip }
  end

  def test_given_a_saved_value_naming_no_hidden_columns_hides_the_columns_its_own_call_hides
    KeystoneUi.configure { |c| c.preference_supplier = ->(_view, _key) { { value: {}, save_url: "/preferences/months" } } }

    columns = month_columns
    page = render_in_view_context do
      ui_data_table(items: [ { month: "Jan", pipeline: "$10" } ], columns: columns, key: :months, hidden_columns: [ :pipeline ])
    end

    assert_equal [ "Month" ], page.css("thead th").map { |header| header.text.strip }
  end

  def test_given_a_saved_empty_list_of_hidden_columns_shows_every_column
    KeystoneUi.configure { |c| c.preference_supplier = ->(_view, _key) { { value: { "hidden_columns" => [] } } } }

    columns = month_columns
    page = render_in_view_context do
      ui_data_table(items: [ { month: "Jan", pipeline: "$10" } ], columns: columns, key: :months, hidden_columns: [ :pipeline ])
    end

    assert_equal [ "Month", "Pipeline" ], page.css("thead th").map { |header| header.text.strip }
  end

  def test_given_a_saved_order_renders_its_hideable_columns_in_that_order
    KeystoneUi.configure { |c| c.preference_supplier = ->(_view, _key) { { value: { "column_order" => [ "outreach", "pipeline" ] } } } }

    columns = three_columns
    page = render_in_view_context do
      ui_data_table(items: [ { month: "Jan", pipeline: "$10", outreach: "$5" } ], columns: columns, key: :months)
    end

    assert_equal [ "Month", "Outreach", "Pipeline" ], page.css("thead th").map { |header| header.text.strip }
  end

  def test_given_no_saved_order_renders_its_columns_in_the_order_they_were_declared
    KeystoneUi.configure { |c| c.preference_supplier = ->(_view, _key) { { value: { "hidden_columns" => [] } } } }

    columns = three_columns
    page = render_in_view_context do
      ui_data_table(items: [ { month: "Jan", pipeline: "$10", outreach: "$5" } ], columns: columns, key: :months)
    end

    assert_equal [ "Month", "Pipeline", "Outreach" ], page.css("thead th").map { |header| header.text.strip }
  end

  def test_given_a_saved_order_naming_some_columns_renders_the_rest_after_them
    KeystoneUi.configure { |c| c.preference_supplier = ->(_view, _key) { { value: { "column_order" => [ "outreach" ] } } } }

    columns = three_columns
    page = render_in_view_context do
      ui_data_table(items: [ { month: "Jan", pipeline: "$10", outreach: "$5" } ], columns: columns, key: :months)
    end

    assert_equal [ "Month", "Outreach", "Pipeline" ], page.css("thead th").map { |header| header.text.strip }
  end

  private

  def three_columns
    month_columns + [ Keystone::Ui::Column.new(:outreach, "Outreach", hideable: true) ]
  end

  def month_columns
    [ Keystone::Ui::Column.new(:month, "Month"), Keystone::Ui::Column.new(:pipeline, "Pipeline", hideable: true) ]
  end
end
