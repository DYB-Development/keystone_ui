# frozen_string_literal: true

require "render_helper"

class Keystone::Ui::FunnelComponentRenderTest < ViewComponent::TestCase
  def steps = [ { label: "Contacts", value: 161 }, { label: "Conversations", value: 42 } ]

  def test_a_joined_funnel_shows_each_steps_value_and_label_beside_its_shape
    page = render_inline(Keystone::Ui::FunnelComponent.new(steps: steps, shape: :joined))

    assert_equal [ [ "161", "Contacts" ], [ "42", "Conversations" ] ],
      page.css(".ks-funnel-joined .ks-funnel-value").map(&:text).zip(page.css(".ks-funnel-joined .ks-funnel-label").map(&:text))
  end
end
