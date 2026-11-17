# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::StatCardReportRenderTest < ViewComponent::TestCase
  def test_offers_every_tone_the_badge_and_status_dot_offer
    assert_equal Keystone::Ui::States::NAMES, Keystone::Ui::StatCardComponent::VARIANT_CLASSES.keys
  end

  def test_puts_each_tones_own_class_on_its_value
    tones = { neutral: "ks-tone-neutral", success: "ks-tone-success", danger: "ks-tone-danger", warning: "ks-tone-warning", info: "ks-tone-info" }
    drawn = tones.keys.to_h { |tone| [ tone, render_inline(Keystone::Ui::StatCardComponent.new(label: "Commits", value: "553", variant: tone)).at_css(".ks-stat-card-value")["class"].split.grep(/\Aks-tone-/).join(" ") ] }

    assert_equal tones, drawn
  end

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
