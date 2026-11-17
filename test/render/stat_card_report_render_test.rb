# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::StatCardReportRenderTest < ViewComponent::TestCase
  def test_shows_a_note_under_its_value
    page = render_inline(Keystone::Ui::StatCardComponent.new(label: "Commits", value: "553", note: "excluding merge commits"))

    assert_equal "excluding merge commits", page.css(".ks-stat-card-value + .ks-stat-card-note").text.strip
  end

  def test_a_compact_card_shows_its_change_beside_its_value
    page = render_inline(Keystone::Ui::StatCardComponent.new(label: "Avg tokens out", value: "302", change: -4.0, compact: true))

    assert_equal "▼ 4.0%", page.css(".ks-stat-card-value .ks-stat-card-change").text.strip
  end

  def test_a_compact_card_shows_its_note_beside_its_value
    page = render_inline(Keystone::Ui::StatCardComponent.new(label: "Avg tokens out", value: "302", note: "vs v22", compact: true))

    assert_equal "vs v22", page.css(".ks-stat-card-value .ks-stat-card-note").text.strip
  end

  def test_draws_a_plain_figure_without_the_card_border_when_asked
    page = render_inline(Keystone::Ui::StatCardComponent.new(label: "Commits", value: "553", plain: true))

    assert_equal [ true, false ], [ page.css(".ks-metric-plain").any?, page.css(".ks-metric-card").any? ]
  end

  def test_shows_its_fallback_muted_when_its_value_is_missing
    page = render_inline(Keystone::Ui::StatCardComponent.new(label: "Reviews", value: "", fallback: "N/A"))

    assert_equal "N/A", page.css(".ks-stat-card-value .ks-stat-card-fallback").text.strip
  end
end
