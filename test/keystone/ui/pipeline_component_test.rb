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
end
