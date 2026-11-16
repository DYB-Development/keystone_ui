# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::ReviewCardComponentRenderTest < ViewComponent::TestCase
  def test_shows_its_id_at_the_left_of_its_header_line
    page = render_card

    assert_equal "variant A", page.at_css(".ks-card > div:first-child > :first-child")&.text&.strip
  end

  def test_shows_its_score_at_the_right_of_its_header_line
    page = render_card(score: "reviewer 0.91")

    assert_equal "reviewer 0.91", page.at_css(".ks-card > div:first-child > :last-child")&.text&.strip
  end

  def test_draws_its_score_in_the_tone_it_is_given
    page = render_card(score: "reviewer 0.76 · 1 finding", score_tone: :warning)

    assert_includes page.at_css(".ks-card > div:first-child > :last-child")["class"].split, "ks-tone-warning"
  end

  def test_shows_its_title_under_its_header_line
    page = render_card

    assert_equal "Fall catalog is here. 40 new pieces.", page.at_css(".ks-card > div:first-child + .ks-card-title")&.text&.strip
  end

  def test_shows_its_body_text_under_its_title
    page = render_card(body: "Layered knits, wool coats, and the boots you asked for.")

    assert_equal "Layered knits, wool coats, and the boots you asked for.", page.at_css(".ks-card-title + .ks-card-summary")&.text&.strip
  end

  def test_shows_a_call_to_action_line_under_its_body_text
    page = render_card(body: "Layered knits, wool coats, and the boots you asked for.", cta: "Shop the catalog →")

    assert_equal "Shop the catalog →", page.at_css(".ks-card-summary + .ks-card-link")&.text&.strip
  end

  def test_shows_its_meta_line_with_a_divider_between_it_and_the_text_above
    page = render_card(meta: "37 chars · tone direct · claims 2/2 sourced")

    assert_equal "37 chars · tone direct · claims 2/2 sourced", page.at_css(".ks-card > .ks-card-meta")&.text&.strip
  end

  def test_shows_a_finding_note_in_the_warning_style
    page = render_card(finding: "Finding: \"finished\" implies completeness not in the brief (severity: low).")

    assert_equal "Finding: \"finished\" implies completeness not in the brief (severity: low).", page.at_css(".ks-card > .ks-alert.ks-alert-warning")&.text&.strip
  end

  def test_draws_its_edge_in_the_warning_style_when_it_has_a_finding_note
    page = render_card(finding: "Finding: \"finished\" implies completeness not in the brief (severity: low).")

    assert_includes page.at_css("article")["class"].split, "ks-card-warning"
  end

  def test_shows_its_actions_as_buttons_in_a_row_where_each_takes_an_equal_share
    page = render_card(actions: [ { label: "Edit", href: "/variants/a/edit" }, { label: "Drop", href: "/variants/a", method: :delete } ])

    assert_equal [ "Edit", "Drop" ], page.css(".ks-card > div[class~='*:flex-1'] .ks-button").map { |button| button.text.strip }
  end

  def test_leaves_out_its_body_text_in_its_compact_form
    page = render_card(body: "Layered knits, wool coats, and the boots you asked for.", compact: true)

    assert_nil page.at_css(".ks-card-summary")
  end

  def test_leaves_out_its_meta_line_in_its_compact_form
    page = render_card(meta: "37 chars · tone direct · claims 2/2 sourced", compact: true)

    assert_nil page.at_css(".ks-card-meta")
  end

  def test_leaves_out_its_call_to_action_line_in_its_compact_form
    page = render_card(cta: "Shop the catalog →", compact: true)

    assert_nil page.at_css(".ks-card-link")
  end

  def test_lets_its_buttons_narrow_from_640_pixels_wide_so_three_take_equal_shares_in_a_third_of_the_page
    page = render_card(actions: [ { label: "Apply fix" }, { label: "Edit" }, { label: "Drop" } ])

    assert_empty %w[sm:[&_.ks-button]:min-w-0 sm:[&_.ks-button]:text-xs] - page.at_css("article")["class"].split
  end

  private

  def render_card(**options)
    render_inline(Keystone::Ui::ReviewCardComponent.new(id: "variant A", title: "Fall catalog is here. 40 new pieces.", **options))
  end
end
