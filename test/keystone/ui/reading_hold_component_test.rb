# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::ReadingHoldComponentTest < Minitest::Test
  def test_passes_the_seconds_already_spent_and_the_end_requirement_to_its_controller
    data = Keystone::Ui::ReadingHoldComponent.new(seconds: 30, elapsed: 5, require_end: true).wrapper_data

    assert_equal({controller: "reading-hold", reading_hold_seconds_value: 30, reading_hold_elapsed_value: 5, reading_hold_require_end_value: true},
      data.slice(:controller, :reading_hold_seconds_value, :reading_hold_elapsed_value, :reading_hold_require_end_value))
  end
end
