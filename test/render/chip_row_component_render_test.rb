# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::ChipRowComponentRenderTest < ViewComponent::TestCase
  def chips
    [
      { label: "Checks", value: "4/4", tone: :success },
      { label: "Findings", value: "1", tone: :warning },
      { label: "p", value: "0.84", tone: :neutral }
    ]
  end

  def test_shows_each_chips_label_and_value_in_that_chips_tone
    page = render_inline(Keystone::Ui::ChipRowComponent.new(chips: chips))

    assert_equal [ [ "ks-chip ks-chip-success", "Checks 4/4" ], [ "ks-chip ks-chip-warning", "Findings 1" ], [ "ks-chip ks-chip-neutral", "p 0.84" ] ],
      page.css(".ks-chip-row > .ks-chip").map { |chip| [ chip["class"], chip.text.squish ] }
  end
end
