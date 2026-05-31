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

  def test_content_for_embeds_the_shared_api_reference
    assert_includes KeystoneUi::Subagents.content_for("keystone-scaffold"), KeystoneUi::Reference.content
  end

  def test_scaffold_agent_includes_the_page_recipes
    assert_includes KeystoneUi::Subagents.content_for("keystone-scaffold"), KeystoneUi::Reference.recipes
  end
end
