# frozen_string_literal: true

require "test_helper"
require_relative "../../../lib/generators/keystone/layout_theme_attributes"

class Keystone::LayoutThemeAttributesTest < Minitest::Test
  def test_adds_the_theme_attributes_helper_to_the_html_tag
    layout = %(<!DOCTYPE html>\n<html lang="en">\n<head></head>\n</html>\n)

    assert_includes Keystone::LayoutThemeAttributes.new(layout).apply, %(<html <%= keystone_theme_attributes %> lang="en">)
  end
end
