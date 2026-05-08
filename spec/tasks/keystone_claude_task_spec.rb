# frozen_string_literal: true

require "fileutils"
require "rake"
require "tmpdir"

RSpec.describe "keystone:claude rake task" do
  let(:tmpdir) { Dir.mktmpdir }
  let(:claude_md_path) { File.join(tmpdir, "CLAUDE.md") }

  before(:all) do
    Rake.application = Rake::Application.new
    Rake.application.rake_require("keystone_ui", [ File.expand_path("../../lib/tasks", __dir__) ])
  end

  before do
    allow(Dir).to receive(:pwd).and_return(tmpdir)
    Rake::Task["keystone:claude"].reenable
  end

  after do
    FileUtils.remove_entry(tmpdir)
  end

  it "creates CLAUDE.md when the file does not exist" do
    expect { Rake::Task["keystone:claude"].invoke }.to output(/written to/).to_stdout
    expect(File.exist?(claude_md_path)).to be true

    content = File.read(claude_md_path)
    expect(content).to start_with("## Keystone UI")
    expect(content).to include("ui_card")
    expect(content).to include("ui_button")
    expect(content).to include("ui_data_table")
  end

  it "documents all helpers" do
    Rake::Task["keystone:claude"].invoke

    content = File.read(claude_md_path)
    %w[
      ui_card ui_button ui_data_table ui_page ui_section ui_grid ui_panel
      ui_card_link ui_page_header ui_alert ui_input ui_textarea ui_form_field
      ui_form_page ui_show_page ui_navbar ui_nav_item ui_nav_dropdown
      ui_bottom_nav ui_bottom_nav_item ui_mobile_header ui_mobile_actions
      ui_settings_link ui_select ui_badge ui_stat_card ui_chart_card
      ui_copy_button ui_modal ui_accordion ui_tab_switcher ui_option_card
      ui_hero ui_feature_grid ui_cta_banner ui_color_picker
    ].each do |helper|
      expect(content).to include(helper), "expected CLAUDE.md to document #{helper}"
    end
  end

  it "includes the do-not-explore preamble" do
    Rake::Task["keystone:claude"].invoke

    content = File.read(claude_md_path)
    expect(content).to include("DO NOT")
    expect(content).to include("explore the keystone_ui gem source code")
  end

  it "documents edge_to_edge parameter for ui_card" do
    Rake::Task["keystone:claude"].invoke

    content = File.read(claude_md_path)
    expect(content).to include("edge_to_edge")
  end

  it "appends to existing CLAUDE.md without clobbering content" do
    File.write(claude_md_path, "# My App\n\nExisting content.\n")

    Rake::Task["keystone:claude"].invoke

    content = File.read(claude_md_path)
    expect(content).to start_with("# My App\n\nExisting content.")
    expect(content).to include("## Keystone UI")
    expect(content).to include("ui_data_table")
  end

  it "replaces the existing section on re-run (idempotent)" do
    File.write(claude_md_path, "# My App\n\nExisting content.\n")

    Rake::Task["keystone:claude"].invoke
    first_run = File.read(claude_md_path)

    Rake::Task["keystone:claude"].reenable
    Rake::Task["keystone:claude"].invoke
    second_run = File.read(claude_md_path)

    expect(second_run).to eq(first_run)
  end
end
