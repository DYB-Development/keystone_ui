# frozen_string_literal: true

require "test_helper"
require_relative "../../lib/keystone_ui/look_choice"

class KeystoneUi::LookChoiceTest < Minitest::Test
  def test_a_page_takes_the_default_look_when_nothing_supplies_one
    choice = KeystoneUi::LookChoice.new(looks: %w[plain material], default: "plain")

    assert_equal "plain", choice.name
  end
end
