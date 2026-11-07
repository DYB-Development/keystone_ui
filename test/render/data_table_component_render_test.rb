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

  def test_renders_a_locked_column_that_is_not_first_as_an_ordinary_column
    columns = [ Keystone::Ui::Column.new(:month, "Month"), Keystone::Ui::Column.new(:pipeline, "Pipeline", locked: true) ]
    page = render_in_view_context do
      ui_data_table(items: [ { month: "Jan", pipeline: "$10" } ], columns: columns)
    end

    assert_empty page.css(".ks-table-header-locked, .ks-table-cell-locked, .sticky")
  end

  def test_gives_a_locked_column_no_checkbox_in_its_columns_menu
    KeystoneUi.configure { |c| c.preference_supplier = ->(_view, _key) { { value: nil, save_url: "/preferences/months" } } }

    columns = [ Keystone::Ui::Column.new(:month, "Month", hideable: true, locked: true), Keystone::Ui::Column.new(:pipeline, "Pipeline", hideable: true) ]
    page = render_in_view_context do
      ui_data_table(items: [ { month: "Jan", pipeline: "$10" } ], columns: columns, key: :months)
    end

    assert_equal [ "pipeline" ], page.css("[data-controller=column-picker] input[type=checkbox]").map { |box| box["value"] }
  end

  def test_given_no_locked_column_keeps_every_column_scrolling_with_the_table
    columns = month_columns
    page = render_in_view_context do
      ui_data_table(items: [ { month: "Jan", pipeline: "$10" } ], columns: columns)
    end

    assert_empty page.css(".ks-table-header-locked, .ks-table-cell-locked, .sticky")
  end

  def test_holds_a_hidden_message_in_its_columns_menu_for_a_change_that_was_not_saved
    KeystoneUi.configure { |c| c.preference_supplier = ->(_view, _key) { { value: nil, save_url: "/preferences/months" } } }

    columns = month_columns
    page = render_in_view_context do
      ui_data_table(items: [ { month: "Jan", pipeline: "$10" } ], columns: columns, key: :months)
    end

    assert_equal [ "Your column changes were not saved." ], page.css("[data-column-picker-target=error].hidden[role=alert]").map { |message| message.text.strip }
  end

  def test_marks_the_row_of_its_current_item_as_current_for_screen_readers
    columns = month_columns
    items = [ { month: "Jan", pipeline: "$10" }, { month: "Feb", pipeline: "$20" } ]
    page = render_in_view_context do
      ui_data_table(items: items, columns: columns, current_row: items.last)
    end

    assert_equal [ "Feb" ], page.css("tbody tr[aria-current=true] td:first-child").map { |cell| cell.text.strip }
  end

  def test_gives_the_row_of_its_current_item_the_current_row_look
    columns = month_columns
    items = [ { month: "Jan", pipeline: "$10" }, { month: "Feb", pipeline: "$20" } ]
    page = render_in_view_context do
      ui_data_table(items: items, columns: columns, current_row: items.last)
    end

    assert_equal [ "Feb" ], page.css("tbody tr.ks-table-row-current td:first-child").map { |cell| cell.text.strip }
  end

  def test_colours_a_row_with_the_colour_its_row_colour_block_names
    columns = month_columns
    items = [ { month: "Jan", colour: :danger }, { month: "Feb", colour: :warning }, { month: "Mar", colour: :success }, { month: "Apr", colour: :info } ]
    page = render_in_view_context do
      ui_data_table(items: items, columns: columns) do |table|
        table.row_colour { |row| row[:colour] }
      end
    end

    assert_equal %w[ks-table-row-danger ks-table-row-warning ks-table-row-success ks-table-row-info], page.css("tbody tr").map { |row| row["class"] }
  end

  def test_keeps_the_current_row_look_on_a_current_row_that_also_has_a_colour
    columns = month_columns
    items = [ { month: "Jan", pipeline: "$10" } ]
    page = render_in_view_context do
      ui_data_table(items: items, columns: columns, current_row: items.first) do |table|
        table.row_colour { |row| :warning }
      end
    end

    assert_equal [ %w[ks-table-row-current ks-table-row-warning] ], page.css("tbody tr").map { |row| row["class"].split }
  end

  def test_puts_a_row_s_detail_in_a_row_under_it_spanning_every_column
    columns = month_columns
    page = render_in_view_context do
      ui_data_table(items: [ { month: "Jan", pipeline: "$10" } ], columns: columns) do |table|
        table.row_detail { |row| "Notes for #{row[:month]}" }
      end
    end

    assert_equal [ [ nil, nil ], [ "2" ] ], page.css("tbody tr").map { |row| row.css("td").map { |cell| cell["colspan"] } }
  end

  def test_shows_what_its_row_detail_block_returns_in_the_detail_row
    columns = month_columns
    page = render_in_view_context do
      ui_data_table(items: [ { month: "Jan", pipeline: "$10" } ], columns: columns) do |table|
        table.row_detail { |row| "Notes for #{row[:month]}" }
      end
    end

    assert_equal [ "Notes for Jan" ], page.css("tbody td[colspan]").map { |cell| cell.text.strip }
  end

  def test_gives_no_detail_row_to_a_row_whose_row_detail_block_returns_nil
    columns = month_columns
    page = render_in_view_context do
      ui_data_table(items: [ { month: "Jan", pipeline: "$10" }, { month: "Feb", pipeline: "$20" } ], columns: columns) do |table|
        table.row_detail { |row| "Notes for Feb" if row[:month] == "Feb" }
      end
    end

    assert_equal [ "Jan", "Feb", "Notes for Feb" ], page.css("tbody tr").map { |row| row.css("td").first.text.strip }
  end

  def test_spans_a_row_s_detail_across_the_actions_column_too
    columns = month_columns
    page = render_in_view_context do
      ui_data_table(items: [ { month: "Jan", pipeline: "$10" } ], columns: columns) do |table|
        table.actions { |row| ui_action_menu_item(label: "Edit", href: "/months/1/edit") }
        table.row_detail { |row| "Notes for #{row[:month]}" }
      end
    end

    assert_equal [ "3" ], page.css("tbody td[colspan]").map { |cell| cell["colspan"] }
  end

  def test_hides_a_row_s_detail_until_it_is_opened
    columns = month_columns
    page = render_in_view_context do
      ui_data_table(items: [ { month: "Jan", pipeline: "$10" } ], columns: columns) do |table|
        table.row_detail { |row| "Notes for #{row[:month]}" }
      end
    end

    assert_equal [ false, true ], page.css("tbody tr").map { |row| row.key?("hidden") }
  end

  def test_gives_a_row_with_detail_a_button_naming_its_detail_row
    columns = month_columns
    page = render_in_view_context do
      ui_data_table(items: [ { month: "Jan", pipeline: "$10" } ], columns: columns) do |table|
        table.row_detail { |row| "Notes for #{row[:month]}" }
      end
    end

    assert_equal page.css("tbody tr[hidden]").map { |row| row["id"] }, page.css("tbody button[aria-controls]").map { |button| button["aria-controls"] }
  end

  def test_marks_the_button_of_a_closed_row_as_not_expanded
    columns = month_columns
    page = render_in_view_context do
      ui_data_table(items: [ { month: "Jan", pipeline: "$10" } ], columns: columns) do |table|
        table.row_detail { |row| "Notes for #{row[:month]}" }
      end
    end

    assert_equal [ "false" ], page.css("tbody button[aria-controls]").map { |button| button["aria-expanded"] }
  end

  def test_labels_the_detail_button_in_plain_words
    columns = month_columns
    page = render_in_view_context do
      ui_data_table(items: [ { month: "Jan", pipeline: "$10" } ], columns: columns) do |table|
        table.row_detail { |row| "Notes for #{row[:month]}" }
      end
    end

    assert_equal [ "Show detail" ], page.css("tbody button[aria-controls]").map { |button| button["aria-label"] }
  end

  def test_shows_a_caret_in_the_detail_button
    columns = month_columns
    page = render_in_view_context do
      ui_data_table(items: [ { month: "Jan", pipeline: "$10" } ], columns: columns) do |table|
        table.row_detail { |row| "Notes for #{row[:month]}" }
      end
    end

    assert_equal 1, page.css("tbody button[aria-controls] svg").length
  end

  def test_turns_the_caret_of_the_detail_button_over_while_its_row_is_open
    columns = month_columns
    page = render_in_view_context do
      ui_data_table(items: [ { month: "Jan", pipeline: "$10" } ], columns: columns) do |table|
        table.row_detail { |row| "Notes for #{row[:month]}" }
      end
    end

    assert_includes page.css("tbody button[aria-controls]").first["class"].to_s.split, "aria-expanded:rotate-180"
  end

  def test_names_a_row_s_detail_after_its_item_s_id_so_a_refresh_keeps_it_with_that_item
    columns = month_columns
    page = render_in_view_context do
      ui_data_table(items: [ { id: 7, month: "Jan", pipeline: "$10" } ], columns: columns) do |table|
        table.row_detail { |row| "Notes for #{row[:month]}" }
      end
    end

    assert_equal [ "row-detail-7" ], page.css("tbody tr[hidden]").map { |row| row["id"] }
  end

  def test_marks_the_detail_button_as_the_row_s_toggle
    columns = month_columns
    page = render_in_view_context do
      ui_data_table(items: [ { month: "Jan", pipeline: "$10" } ], columns: columns) do |table|
        table.row_detail { |row| "Notes for #{row[:month]}" }
      end
    end

    assert_equal [ "toggle" ], page.css("tbody button[aria-controls]").map { |button| button["data-row-detail-target"] }
  end

  private

  def three_columns
    month_columns + [ Keystone::Ui::Column.new(:outreach, "Outreach", hideable: true) ]
  end

  def month_columns
    [ Keystone::Ui::Column.new(:month, "Month"), Keystone::Ui::Column.new(:pipeline, "Pipeline", hideable: true) ]
  end
end
