# frozen_string_literal: true

require "test_helper"

class KeystoneUi::ConfigurationTest < Minitest::Test
  def teardown
    KeystoneUi.reset_configuration!
  end

  def test_defaults_accent_to_blue
    assert_equal :blue, KeystoneUi.configuration.accent
  end

  def test_defaults_surface_to_zinc
    assert_equal :zinc, KeystoneUi.configuration.surface
  end

  def test_allows_setting_accent_via_configure_block
    KeystoneUi.configure { |c| c.accent = :emerald }

    assert_equal :emerald, KeystoneUi.configuration.accent
  end

  def test_allows_setting_surface_via_configure_block
    KeystoneUi.configure { |c| c.surface = :slate }

    assert_equal :slate, KeystoneUi.configuration.surface
  end

  def test_supplies_no_theme_mode_when_no_gem_supplies_one
    assert_nil KeystoneUi.configuration.supplied_theme_mode(Object.new)
  end

  def test_supplies_the_theme_mode_a_registered_supplier_returns_for_the_view
    view = Struct.new(:saved_mode).new("dark")
    KeystoneUi.configure { |c| c.theme_mode_supplier = ->(from) { from.saved_mode } }

    assert_equal "dark", KeystoneUi.configuration.supplied_theme_mode(view)
  end

  def test_starts_with_no_tailwind_files_registered_for_import
    assert_equal [], KeystoneUi::Configuration.new.tailwind_imports
  end

  def test_starts_with_no_source_files_registered_for_scanning
    assert_equal [], KeystoneUi::Configuration.new.tailwind_sources
  end

  def test_registers_a_look_by_name_with_the_path_of_its_css_file
    KeystoneUi.configure { |c| c.register_look :material, "/app/assets/tailwind/looks/material.css" }

    assert_equal({ "material" => "/app/assets/tailwind/looks/material.css" }, KeystoneUi.configuration.looks)
  end

  def test_registering_a_look_adds_its_file_to_the_tailwind_imports
    KeystoneUi.configure { |c| c.register_look :material, "/app/assets/tailwind/looks/material.css" }

    assert_includes KeystoneUi.configuration.tailwind_imports, "/app/assets/tailwind/looks/material.css"
  end

  def test_names_a_default_look
    KeystoneUi.configure { |c| c.default_look = :material }

    assert_equal "material", KeystoneUi.configuration.default_look
  end

  def test_supplies_no_look_when_no_gem_supplies_one
    assert_nil KeystoneUi.configuration.supplied_look(Object.new)
  end

  def test_supplies_the_look_a_registered_supplier_returns_for_the_view
    view = Struct.new(:saved_look).new("material")
    KeystoneUi.configure { |c| c.look_supplier = ->(from) { from.saved_look } }

    assert_equal "material", KeystoneUi.configuration.supplied_look(view)
  end

  def test_supplies_no_trail_when_no_app_supplies_one
    assert_nil KeystoneUi.configuration.supplied_trail(Object.new)
  end

  def test_supplies_the_trail_a_registered_supplier_returns_for_the_view
    view = Struct.new(:page_trail).new([ [ "Invoices", "/invoices" ] ])
    KeystoneUi.configure { |c| c.trail_supplier = ->(from) { from.page_trail } }

    assert_equal [ [ "Invoices", "/invoices" ] ], KeystoneUi.configuration.supplied_trail(view)
  end
end
