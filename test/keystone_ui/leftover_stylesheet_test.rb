# frozen_string_literal: true

require "test_helper"
require "tmpdir"
require_relative "../../lib/keystone_ui/leftover_stylesheet"

class KeystoneUi::LeftoverStylesheetTest < Minitest::Test
  def test_removes_the_stylesheet_tailwindcss_rails_generated_for_older_versions
    Dir.mktmpdir do |root|
      leftover = Pathname.new(root).join("app/assets/builds/tailwind/keystone_ui_engine.css")
      leftover.dirname.mkpath
      leftover.write(%(@import "/old/gem/engine.css";))

      KeystoneUi::LeftoverStylesheet.new(root).remove

      refute leftover.exist?
    end
  end
end
