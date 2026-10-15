# frozen_string_literal: true

require "test_helper"
require "active_support/core_ext/string/output_safety"
require_relative "../../app/helpers/keystone_ui_helper"

class KeystoneUi::TextHelperTest < Minitest::Test
  class View
    include KeystoneUiHelper

    attr_reader :rendered

    def render(component)
      @rendered = component
    end
  end

  def test_renders_a_heading_with_its_text_and_note
    view = View.new

    view.ui_heading(text: "Work", note: "12.5 billable hours")

    assert_equal [ "Work", "12.5 billable hours" ], [ view.rendered.text, view.rendered.note ]
  end

  def test_renders_a_caption_with_its_text
    view = View.new

    view.ui_caption(text: "Work report")

    assert_equal "Work report", view.rendered.text
  end

  def test_renders_a_paragraph_with_its_text
    view = View.new

    view.ui_paragraph(text: "Work from 1 to 30 September.")

    assert_equal "Work from 1 to 30 September.", view.rendered.text
  end

  def test_renders_a_value_list_with_its_rows
    view = View.new

    view.ui_value_list(rows: [ { label: "Rate", value: "$150.00" } ])

    assert_equal [ { label: "Rate", value: "$150.00" } ], view.rendered.rows
  end
end
