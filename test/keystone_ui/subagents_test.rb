# frozen_string_literal: true

require "test_helper"
require_relative "../../lib/keystone_ui/subagents"

class KeystoneUiSubagentsTest < Minitest::Test
  def test_names_include_the_scaffold_agent
    assert_includes KeystoneUi::Subagents.names, "keystone-scaffold"
  end

  def test_content_for_renders_frontmatter_with_the_agent_name
    assert_includes KeystoneUi::Subagents.content_for("keystone-scaffold"), "name: keystone-scaffold"
  end
end
