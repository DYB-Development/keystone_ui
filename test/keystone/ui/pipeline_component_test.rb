# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::PipelineComponentTest < Minitest::Test
  def test_exposes_title
    component = Keystone::Ui::PipelineComponent.new(
      title: "Order fulfilment",
      boxes: [ { label: "Placed" } ],
      links: []
    )

    assert_equal "Order fulfilment", component.title
  end

  def test_count_class_maps_emerald_accent_to_the_keystone_accent
    component = Keystone::Ui::PipelineComponent.new(title: "T", boxes: [], links: [])

    assert_includes component.count_class(:emerald), "text-accent-400"
  end
end
