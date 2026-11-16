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

  private

  def render_card(**options)
    render_inline(Keystone::Ui::ReviewCardComponent.new(id: "variant A", title: "Fall catalog is here. 40 new pieces.", **options))
  end
end
