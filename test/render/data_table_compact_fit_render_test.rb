# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::DataTableCompactFitRenderTest < ViewComponent::TestCase
  PANEL_WIDTH = 805
  TABLE_BORDERS = 2
  WIDEST_GLYPH_EM = 0.6
  WIDEST_CAPITAL_GLYPH_EM = 0.8
  FONT_SIZES = { "text-xs" => 12, "text-sm" => 14, "ks-label-caps" => 12 }.freeze
  SIDE_PADDING = { "ks-table-compact" => 20, "ks-table-header-first" => 36, "ks-table-cell-first" => 36, "ks-table-header-middle" => 24, "ks-table-cell-middle" => 24, "ks-table-header-last" => 36, "ks-table-cell-last" => 36 }.freeze

  COLUMNS = [ { version: "Version" }, { alias: "Alias" }, { model: "Model" }, { p_correct: "p_correct" }, { n: "n" }, { conformance: "Conformance" }, { cost: "Cost" }, { p50: "p50" }, { dataset: "Dataset" } ].freeze
  VERSION_ROW = { version: "v22", alias: "candidate", model: "claude-sonnet-5-5", p_correct: "0.84", n: "1,920", conformance: "—", cost: "$0.02", p50: "7.0s", dataset: "golden-v3" }.freeze

  def test_given_compact_density_the_nine_column_versions_table_fits_an_805px_panel_with_every_value_on_one_line
    page = render_in_view_context do
      ui_data_table(items: [ VERSION_ROW ], columns: COLUMNS, heading_caps: true, density: :compact)
    end

    assert_operator one_line_width(page), :<=, PANEL_WIDTH
  end

  private

  def one_line_width(page)
    rows = page.css("tr").map { |row| row.css("th, td").map { |cell| cell_width(cell) } }

    rows.transpose.sum(&:max) + TABLE_BORDERS
  end

  def cell_width(cell)
    classes = cell["class"].split

    side_padding(classes) + text_width(cell.text.strip, classes)
  end

  def side_padding(classes)
    SIDE_PADDING.fetch(classes.include?("ks-table-compact") ? "ks-table-compact" : (classes & SIDE_PADDING.keys).first)
  end

  def text_width(text, classes)
    font_size = FONT_SIZES.fetch((classes & FONT_SIZES.keys).last)
    glyph_em = classes.include?("ks-label-caps") ? WIDEST_CAPITAL_GLYPH_EM : WIDEST_GLYPH_EM

    text.length * font_size * glyph_em
  end
end
