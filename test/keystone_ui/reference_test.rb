# frozen_string_literal: true

require "test_helper"
require_relative "../../lib/keystone_ui/reference"

class KeystoneUiReferenceTest < Minitest::Test
  def test_content_includes_a_documented_helper
    assert_includes KeystoneUi::Reference.content, "ui_button"
  end

  def test_recipes_documents_the_index_page_scenario
    assert_includes KeystoneUi::Reference.recipes, "Index page"
  end
end
