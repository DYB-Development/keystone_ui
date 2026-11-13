# frozen_string_literal: true

require "test_helper"
require "active_support/core_ext/string/output_safety"
require_relative "../../app/helpers/keystone_ui_helper"

class KeystoneUi::TimelineHelperTest < Minitest::Test
  class View
    include KeystoneUiHelper

    attr_reader :rendered

    def render(component)
      @rendered = component
    end
  end

  def test_renders_a_timeline_with_its_entries
    view = View.new
    entries = [ { label: "Plan", started_at: Time.utc(2026, 11, 13, 9), ended_at: Time.utc(2026, 11, 13, 9, 1) } ]

    view.ui_timeline(entries: entries)

    assert_equal entries, view.rendered.entries
  end
end
