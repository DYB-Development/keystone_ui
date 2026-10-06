# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::FunnelComponentRenderTest < ViewComponent::TestCase
  def steps = [ { label: "Contacts", value: 161 }, { label: "Conversations", value: 42 } ]

  def test_a_joined_funnel_shows_each_steps_value_and_label_beside_its_shape
    page = render_inline(Keystone::Ui::FunnelComponent.new(steps: steps, shape: :joined))

    assert_equal [ [ "161", "Contacts" ], [ "42", "Conversations" ] ],
      page.css(".ks-funnel-joined .ks-funnel-value").map(&:text).zip(page.css(".ks-funnel-joined .ks-funnel-label").map(&:text))
  end

  def test_a_joined_funnel_shows_the_percent_on_the_band_between_two_steps
    page = render_inline(Keystone::Ui::FunnelComponent.new(steps: steps, shape: :joined))

    assert_equal [ "26%" ], page.css(".ks-funnel-band-label").map(&:text)
  end

  def test_a_joined_funnel_draws_each_block_at_its_share_of_the_top_step
    page = render_inline(Keystone::Ui::FunnelComponent.new(steps: steps, shape: :joined))

    assert_equal "width: 26%", page.at_css(".ks-funnel-joined .ks-funnel-bar-sky")&.[]("style")
  end

  def test_a_joined_funnel_band_narrows_from_one_block_to_the_next
    page = render_inline(Keystone::Ui::FunnelComponent.new(steps: steps, shape: :joined))

    assert_equal "clip-path: polygon(0% 0, 100% 0, 63% 100%, 37% 100%)", page.at_css(".ks-funnel-band")&.[]("style")
  end
end
