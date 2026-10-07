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

  def test_lists_the_columns_in_its_columns_menu_in_the_order_it_shows_them
    KeystoneUi.configure { |c| c.preference_supplier = ->(_view, _key) { { value: { "column_order" => [ "outreach", "pipeline" ] }, save_url: "/preferences/months" } } }

    columns = three_columns
    page = render_in_view_context do
      ui_data_table(items: [ { month: "Jan", pipeline: "$10", outreach: "$5" } ], columns: columns, key: :months)
    end

    assert_equal [ "outreach", "pipeline" ], page.css("[data-controller=column-picker] input[type=checkbox]").map { |box| box["value"] }
  end

  def test_gives_each_column_in_its_columns_menu_an_up_button
    KeystoneUi.configure { |c| c.preference_supplier = ->(_view, _key) { { value: nil, save_url: "/preferences/months" } } }

    columns = three_columns
    page = render_in_view_context do
      ui_data_table(items: [ { month: "Jan", pipeline: "$10", outreach: "$5" } ], columns: columns, key: :months)
    end

    assert_equal 2, page.css("button[data-action=\"click->column-picker#moveUp\"]").size
  end

  def test_labels_each_up_button_in_plain_words_whatever_its_column_header_holds
    KeystoneUi.configure { |c| c.preference_supplier = ->(_view, _key) { { value: nil, save_url: "/preferences/months" } } }

    columns = [ Keystone::Ui::Column.new(:month, "Month"), Keystone::Ui::Column.new(:pipeline, "<b>Pipeline</b>".html_safe, hideable: true) ]
    page = render_in_view_context do
      ui_data_table(items: [ { month: "Jan", pipeline: "$10" } ], columns: columns, key: :months)
    end

    assert_equal [ "Move up" ], page.css("button[data-action=\"click->column-picker#moveUp\"]").map { |button| button["aria-label"] }
  end

  def test_gives_each_column_in_its_columns_menu_a_down_button
    KeystoneUi.configure { |c| c.preference_supplier = ->(_view, _key) { { value: nil, save_url: "/preferences/months" } } }

    columns = three_columns
    page = render_in_view_context do
      ui_data_table(items: [ { month: "Jan", pipeline: "$10", outreach: "$5" } ], columns: columns, key: :months)
    end

    assert_equal [ "Move down", "Move down" ], page.css("button[data-action=\"click->column-picker#moveDown\"]").map { |button| button["aria-label"] }
  end

  def test_disables_the_up_button_of_the_first_column_in_its_columns_menu
    KeystoneUi.configure { |c| c.preference_supplier = ->(_view, _key) { { value: nil, save_url: "/preferences/months" } } }

    columns = three_columns
    page = render_in_view_context do
      ui_data_table(items: [ { month: "Jan", pipeline: "$10", outreach: "$5" } ], columns: columns, key: :months)
    end

    assert_equal [ true, false ], page.css("button[data-action=\"click->column-picker#moveUp\"]").map { |button| button.key?("disabled") }
  end

  def test_disables_the_down_button_of_the_last_column_in_its_columns_menu
    KeystoneUi.configure { |c| c.preference_supplier = ->(_view, _key) { { value: nil, save_url: "/preferences/months" } } }

    columns = three_columns
    page = render_in_view_context do
      ui_data_table(items: [ { month: "Jan", pipeline: "$10", outreach: "$5" } ], columns: columns, key: :months)
    end

    assert_equal [ false, true ], page.css("button[data-action=\"click->column-picker#moveDown\"]").map { |button| button.key?("disabled") }
  end

  def test_puts_its_columns_menu_in_a_row_above_itself_aligned_right
    KeystoneUi.configure { |c| c.preference_supplier = ->(_view, _key) { { value: nil, save_url: "/preferences/months" } } }

    columns = month_columns
    page = render_in_view_context do
      ui_data_table(items: [ { month: "Jan", pipeline: "$10" } ], columns: columns, key: :months)
    end

    assert_equal [ %w[ks-table-toolbar flex justify-end] ], page.css("div:has(> [data-controller=column-picker])").map { |row| row["class"].split }
  end

  def test_greys_the_name_of_a_hidden_column_in_its_columns_menu
    KeystoneUi.configure { |c| c.preference_supplier = ->(_view, _key) { { value: { "hidden_columns" => [ "pipeline" ] }, save_url: "/preferences/months" } } }

    columns = three_columns
    page = render_in_view_context do
      ui_data_table(items: [ { month: "Jan", pipeline: "$10", outreach: "$5" } ], columns: columns, key: :months)
    end

    assert_equal({ "pipeline" => true, "outreach" => false }, page.css("[data-controller=column-picker] label").to_h { |label| [ label.at_css("input")["value"], label["class"].split.include?("ks-menu-option-hidden") ] })
  end

  def test_keeps_the_header_of_a_locked_first_column_in_place_while_the_rest_scrolls
    columns = [ Keystone::Ui::Column.new(:month, "Month", locked: true), Keystone::Ui::Column.new(:pipeline, "Pipeline") ]
    page = render_in_view_context do
      ui_data_table(items: [ { month: "Jan", pipeline: "$10" } ], columns: columns)
    end

    assert_empty %w[ks-table-header-locked sticky left-0] - page.css("thead th").first["class"].split
  end

  def test_keeps_the_cells_of_a_locked_first_column_in_place_while_the_rest_scrolls
    columns = [ Keystone::Ui::Column.new(:month, "Month", locked: true), Keystone::Ui::Column.new(:pipeline, "Pipeline") ]
    page = render_in_view_context do
      ui_data_table(items: [ { month: "Jan", pipeline: "$10" } ], columns: columns)
    end

    assert_empty %w[ks-table-cell-locked sticky left-0] - page.css("tbody td").first["class"].split
  end

  private

  def three_columns
    month_columns + [ Keystone::Ui::Column.new(:outreach, "Outreach", hideable: true) ]
  end

  def month_columns
    [ Keystone::Ui::Column.new(:month, "Month"), Keystone::Ui::Column.new(:pipeline, "Pipeline", hideable: true) ]
  end
end
