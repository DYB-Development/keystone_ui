# frozen_string_literal: true

require "test_helper"

class Keystone::Ui::ReadingHoldComponentTest < Minitest::Test
  def test_passes_the_seconds_already_spent_and_the_end_requirement_to_its_controller
    data = Keystone::Ui::ReadingHoldComponent.new(seconds: 30, elapsed: 5, require_end: true).wrapper_data

    assert_equal({controller: "reading-hold", reading_hold_seconds_value: 30, reading_hold_elapsed_value: 5, reading_hold_require_end_value: true},
      data.slice(:controller, :reading_hold_seconds_value, :reading_hold_elapsed_value, :reading_hold_require_end_value))
  end

  def test_passes_the_page_wording_for_waiting_and_for_becoming_available_to_its_controller
    data = Keystone::Ui::ReadingHoldComponent.new(waiting: "Wait {seconds}s", end_waiting: "Scroll to the end", ready: "Ready").wrapper_data

    assert_equal ["Wait {seconds}s", "Scroll to the end", "Ready"], data.values_at(:reading_hold_waiting_value, :reading_hold_end_waiting_value, :reading_hold_ready_value)
  end

  def test_gives_the_page_button_options_that_describe_the_button_by_the_hold_status
    hold = Keystone::Ui::ReadingHoldComponent.new(seconds: 30)

    assert_equal({data: {reading_hold_target: "button"}, aria: {describedby: hold.status_id}}, hold.button_options)
  end

  def test_listens_for_turbo_caching_the_page_and_for_the_browser_restoring_it
    data = Keystone::Ui::ReadingHoldComponent.new.wrapper_data

    assert_equal "turbo:before-cache@document->reading-hold#holdForCache pageshow@window->reading-hold#restore", data[:action]
  end

  def test_the_announcement_is_read_out_but_not_shown
    assert_equal "sr-only", Keystone::Ui::ReadingHoldComponent::ANNOUNCER_CLASSES
  end

  def test_names_the_fields_its_form_sends_under_the_page_prefix
    hold = Keystone::Ui::ReadingHoldComponent.new(field_prefix: "acceptance")

    assert_equal ["acceptance[end_reached]", "acceptance[end_in_view_on_load]"], [hold.end_reached_field, hold.in_view_on_load_field]
  end
end
