# frozen_string_literal: true

require "test_helper"
require "minitest/mock"
require "fileutils"
require "rake"
require "tmpdir"

class KeystoneClaudeTaskTest < Minitest::Test
  def self.startup
    Rake.application = Rake::Application.new
    Rake.application.rake_require("keystone_ui", [ File.expand_path("../../lib/tasks", __dir__) ])
  end
  startup

  def setup
    @tmpdir = Dir.mktmpdir
    @claude_md_path = File.join(@tmpdir, "CLAUDE.md")
    Rake::Task["keystone:claude"].reenable
  end

  def teardown
    FileUtils.remove_entry(@tmpdir) if @tmpdir && File.exist?(@tmpdir)
  end

  def test_creates_claude_md_when_the_file_does_not_exist
    Dir.stub :pwd, @tmpdir do
      out, _err = capture_io { Rake::Task["keystone:claude"].invoke }
      assert_match(/written to/, out)
      assert File.exist?(@claude_md_path)

      content = File.read(@claude_md_path)
      assert content.start_with?("## Keystone UI")
      assert_includes content, "ui_card"
      assert_includes content, "ui_button"
      assert_includes content, "ui_data_table"
    end
  end

  def test_documents_all_helpers
    Dir.stub :pwd, @tmpdir do
      capture_io { Rake::Task["keystone:claude"].invoke }
    end

    content = File.read(@claude_md_path)
    %w[
      ui_card ui_button ui_data_table ui_page ui_section ui_grid ui_panel
      ui_card_link ui_page_header ui_alert ui_input ui_textarea ui_form_field
      ui_form_page ui_show_page ui_navbar ui_nav_item ui_nav_dropdown
      ui_bottom_nav ui_bottom_nav_item ui_mobile_header ui_mobile_actions
      ui_settings_link ui_select ui_badge ui_stat_card ui_chart_card
      ui_copy_button ui_modal ui_accordion ui_tab_switcher ui_option_card
      ui_hero ui_feature_grid ui_cta_banner ui_color_picker
    ].each do |helper|
      assert_includes content, helper, "expected CLAUDE.md to document #{helper}"
    end
  end

  def test_includes_the_do_not_explore_preamble
    Dir.stub :pwd, @tmpdir do
      capture_io { Rake::Task["keystone:claude"].invoke }
    end

    content = File.read(@claude_md_path)
    assert_includes content, "DO NOT"
    assert_includes content, "explore the keystone_ui gem source code"
  end

  def test_documents_edge_to_edge_parameter_for_ui_card
    Dir.stub :pwd, @tmpdir do
      capture_io { Rake::Task["keystone:claude"].invoke }
    end

    content = File.read(@claude_md_path)
    assert_includes content, "edge_to_edge"
  end

  def test_appends_to_existing_claude_md_without_clobbering_content
    File.write(@claude_md_path, "# My App\n\nExisting content.\n")

    Dir.stub :pwd, @tmpdir do
      capture_io { Rake::Task["keystone:claude"].invoke }
    end

    content = File.read(@claude_md_path)
    assert content.start_with?("# My App\n\nExisting content.")
    assert_includes content, "## Keystone UI"
    assert_includes content, "ui_data_table"
  end

  def test_replaces_the_existing_section_on_re_run_idempotent
    File.write(@claude_md_path, "# My App\n\nExisting content.\n")

    Dir.stub :pwd, @tmpdir do
      capture_io { Rake::Task["keystone:claude"].invoke }
    end
    first_run = File.read(@claude_md_path)

    Rake::Task["keystone:claude"].reenable
    Dir.stub :pwd, @tmpdir do
      capture_io { Rake::Task["keystone:claude"].invoke }
    end
    second_run = File.read(@claude_md_path)

    assert_equal first_run, second_run
  end
end
