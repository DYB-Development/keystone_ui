# frozen_string_literal: true

require "test_helper"
require_relative "../../lib/keystone_ui/look_choice"

class KeystoneUi::LookChoiceTest < Minitest::Test
  def test_a_page_takes_the_default_look_when_nothing_supplies_one
    choice = KeystoneUi::LookChoice.new(looks: %w[plain material], default: "plain")

    assert_equal "plain", choice.name
  end

  def test_a_page_takes_a_registered_look_a_gem_supplies
    choice = KeystoneUi::LookChoice.new(looks: %w[plain material], default: "plain", supplied: "material")

    assert_equal "material", choice.name
  end

  def test_marks_the_html_tag_with_the_look
    choice = KeystoneUi::LookChoice.new(looks: %w[plain], default: "plain")

    assert_equal({ "data-look" => "plain" }, choice.html_attributes)
  end

  def test_leaves_the_html_tag_unmarked_when_no_looks_are_registered
    choice = KeystoneUi::LookChoice.new(looks: [], default: nil)

    assert_equal({}, choice.html_attributes)
  end

  def test_a_page_keeps_the_default_look_when_a_gem_supplies_an_unregistered_one
    choice = KeystoneUi::LookChoice.new(looks: %w[plain], default: "plain", supplied: "retired")

    assert_equal "plain", choice.name
  end
end
