# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::FactsComponentRenderTest < ViewComponent::TestCase
  def test_shows_each_fact_with_its_count_in_bold_beside_its_label
    page = render_inline(Keystone::Ui::FactsComponent.new(facts: [ { value: 12, label: "questions" }, { value: 3, label: "rounds" } ]))

    assert_equal [ [ "12", "12 questions" ], [ "3", "3 rounds" ] ],
      page.css(".ks-facts .ks-fact").map { |fact| [ fact.at_css("b.ks-tone-neutral")&.text, fact.text.strip ] }
  end
end
