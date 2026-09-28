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
end
