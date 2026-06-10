# frozen_string_literal: true

require "test_helper"
require "the_local"
require "keystone_ui/the_local"

module KeystoneUi
  class CompanionTest < Minitest::Test
    def setup
      TheLocal.reset!
      KeystoneUi::Companion.register!
    end

    def test_registers_the_keystone_locals
      assert_equal %w[keystone-scaffold keystone-review keystone-usage keystone-install],
                   TheLocal.registry.agents.map(&:qualified_name)
    end

    def test_committed_agent_files_match_the_registration
      TheLocal.registry.agents.each do |agent|
        assert_equal agent.to_markdown, File.read(agent.source_path)
      end
    end
  end
end
