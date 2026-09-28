# frozen_string_literal: true

require "test_helper"
require "tmpdir"
require_relative "../../lib/keystone_ui/look_check"

class KeystoneUi::LookCheckTest < Minitest::Test
  def test_a_look_whose_file_does_not_exist_stops_boot_naming_the_look
    error = assert_raises(KeystoneUi::LookCheck::Error) do
      KeystoneUi::LookCheck.new(looks: { "material" => "/nowhere/material.css" }, default: nil).call
    end

    assert_includes error.message, "material"
  end

  def test_a_look_whose_file_sets_no_variables_under_its_name_stops_boot_naming_the_look
    Dir.mktmpdir do |dir|
      path = File.join(dir, "material.css")
      File.write(path, ":root { --ks-radius-control: 9999px; }")

      error = assert_raises(KeystoneUi::LookCheck::Error) do
        KeystoneUi::LookCheck.new(looks: { "material" => path }, default: nil).call
      end

      assert_includes error.message, "material"
    end
  end

  def test_a_default_look_that_is_not_registered_stops_boot
    assert_raises(KeystoneUi::LookCheck::Error) do
      KeystoneUi::LookCheck.new(looks: {}, default: "material").call
    end
  end

  def test_a_look_whose_file_sets_variables_under_its_name_passes
    Dir.mktmpdir do |dir|
      path = File.join(dir, "material.css")
      File.write(path, %(:root[data-look="material"] { --ks-radius-control: 9999px; }))

      assert_nil KeystoneUi::LookCheck.new(looks: { "material" => path }, default: "material").call
    end
  end
end
