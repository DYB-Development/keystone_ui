# frozen_string_literal: true

require "test_helper"
require "active_support/core_ext/string/output_safety"
require_relative "../../app/helpers/keystone_ui_helper"

class KeystoneUi::InfoHelperTest < Minitest::Test
  class View
    include KeystoneUiHelper

    attr_reader :rendered, :given

    def render(component, &block)
      @rendered = component
      @given = block&.call
    end
  end

  def test_renders_an_info_holding_what_it_is_given
    view = View.new

    view.ui_info(summary: "Price minus cost of goods") { "the working" }

    assert_equal [ "Price minus cost of goods", "the working" ], [ view.rendered.summary, view.given ]
  end

  def test_renders_a_breakdown_of_amounts_and_their_total
    view = View.new

    view.ui_breakdown(lines: [ { amount: "+$25.00", label: "Lawn mow" } ], total: { amount: "$25.00", label: "Total" })

    assert_equal [ [ { amount: "+$25.00", label: "Lawn mow" } ], { amount: "$25.00", label: "Total" } ], [ view.rendered.lines, view.rendered.total ]
  end
end
