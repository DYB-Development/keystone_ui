# frozen_string_literal: true

require "test_helper"
require "tailwindcss/ruby"
require "tmpdir"
require_relative "../../lib/keystone_ui/source_css"

class KeystoneUi::HostStylesheetTest < Minitest::Test
  ROOT = File.expand_path("../..", __dir__)

  def test_a_host_build_importing_keystone_source_compiles_keystone_ui_styles_classes
    assert_match(/\.ks-button\s*\{/, compile_host_stylesheet)
  end

  private

  def compile_host_stylesheet
    Dir.mktmpdir do |dir|
      File.write(File.join(dir, "keystone_source.css"), KeystoneUi::SourceCss.new(ROOT).to_s)
      File.write(File.join(dir, "application.css"), %(@import "tailwindcss";\n@import "./keystone_source.css";\n))
      output = File.join(dir, "out.css")
      system(Tailwindcss::Ruby.executable, "-i", File.join(dir, "application.css"), "-o", output, chdir: dir, exception: true, err: File::NULL)
      File.read(output)
    end
  end
end
