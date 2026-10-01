# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::BreakdownComponentRenderTest < ViewComponent::TestCase
  def lines = [ { amount: "+$25.00", label: "Lawn mow" }, { amount: "+$14.00", label: "Edging" }, { amount: "−$17.00", label: "Fuel" } ]

  def test_a_breakdown_lists_each_amount_beside_what_it_is
    page = render_inline(Keystone::Ui::BreakdownComponent.new(lines: lines, total: { amount: "$22.00", label: "Total" }))

    assert_equal [ [ "+$25.00", "Lawn mow" ], [ "+$14.00", "Edging" ], [ "−$17.00", "Fuel" ] ],
      page.css(".ks-breakdown-line").map { |line| [ line.at_css(".ks-breakdown-amount").text.strip, line.at_css(".ks-breakdown-label").text.strip ] }
  end

  def test_a_breakdown_ends_with_its_total
    page = render_inline(Keystone::Ui::BreakdownComponent.new(lines: lines, total: { amount: "$22.00", label: "Total" }))

    assert_equal [ "$22.00", "Total" ], [ page.at_css(".ks-breakdown-total .ks-breakdown-amount")&.text&.strip, page.at_css(".ks-breakdown-total .ks-breakdown-label")&.text&.strip ]
  end
end
