# frozen_string_literal: true

require "test_helper"
require_relative "../../lib/keystone_ui/subagents"

class KeystoneUiSubagentsTest < Minitest::Test
  def test_names_include_the_scaffold_agent
    assert_includes KeystoneUi::Subagents.names, "keystone-scaffold"
  end
end
